import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace_flow/common/translation/app_localizations.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/design_system/ui_theme.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.screen.dart';

/// The app rendered by one layout-overlay engine — one instance of this per attached
/// screen (see `LayoutOverlayService.swift`: one native window and one engine per
/// physical screen, since neither a single Flutter view nor a single engine can
/// correctly serve more than one display at once here). Like the blocked page it runs
/// in its own isolate with no provider container: the draft arrives over [_channel]
/// and every edit goes back the same way, not just the final result.
class LayoutOverlayApp extends StatefulWidget {
  const LayoutOverlayApp({super.key});

  @override
  State<LayoutOverlayApp> createState() => _LayoutOverlayAppState();
}

class _LayoutOverlayAppState extends State<LayoutOverlayApp> {
  static const MethodChannel _channel = MethodChannel('de.coodoo.workspace_flow/layout_overlay');

  /// Which screen this particular engine instance renders — null until the first
  /// `update` arrives.
  ScreenInfo? _screen;
  List<ScreenInfo> _allScreens = const [];

  /// Only this screen's own tiles — native pre-filters them from the full draft it
  /// tracks across every screen's engine.
  ///
  /// This is only ever an *initial seed* for [LayoutOverlayScreen], which copies it
  /// into its own local state once and owns it from then on (every local edit —
  /// drag, resize, remove — only ever flows *out* via `onWindowsChanged`, never back
  /// in here). Keeping this field "correct" after that point is neither possible nor
  /// needed: a `windowAdded` push must never be appended to it and re-seeded through
  /// (see that handler below for why that used to resurrect tiles removed earlier
  /// this session).
  List<ProjectWindow> _windows = const [];

  /// Every screen's tiles, this one's included — kept current by native's
  /// `allWindowsChanged` broadcast whenever any screen's list changes. Used only to
  /// keep the "apps still available" row honest across screens; the tiles actually
  /// rendered on this screen still come from [_windows] alone.
  List<ProjectWindow> _allWindows = const [];

  List<AppLibraryEntry> _library = const [];
  Map<String, Uint8List> _icons = const {};

  /// A live preview pushed from another screen's own in-progress drag — see the
  /// class doc on [LayoutOverlayScreen.onDragPreview]. Cleared as soon as that drag
  /// moves off this screen's area again or ends.
  ProjectWindow? _previewWindow;

  /// A tile just moved here from another screen's own drag — see the class doc on
  /// [LayoutOverlayScreen.pendingAddedWindow]. Paired with [_addedWindowToken] so
  /// [LayoutOverlayScreen] can tell one push apart from the next even if the window
  /// data itself happened to be identical.
  ProjectWindow? _pendingAddedWindow;
  int _addedWindowToken = 0;

  /// Bumped on every `update`, and used as [LayoutOverlayScreen]'s key.
  ///
  /// The overlay window and its engine are reused across separate "Arrange on
  /// screen" sessions rather than recreated, so without a changing key Flutter
  /// would treat each `update` as a mere prop change to the *same* element —
  /// leaving `_LayoutOverlayScreenState`'s `late final _windows` (copied from
  /// `widget.windows` exactly once) stuck on whichever project's windows happened
  /// to be the first ever shown this session.
  int _revision = 0;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'update':
          final arguments = call.arguments;
          if (arguments is Map) {
            setState(() {
              _read(arguments);
              _revision++;
            });
          }
        case 'windowAdded':
          // Another screen's isolate just moved a tile onto this one. This must
          // *not* bump `_revision`: that would recreate `LayoutOverlayScreen`'s
          // state and re-seed its local `_windows` from `_windows` here — which is
          // only ever this engine's *initial* seed and has not tracked a single
          // local edit since (removes, drags, resizes all only ever flow outward).
          // Re-seeding from it would silently resurrect every tile removed earlier
          // this session. Handed to the already-live screen as a prop instead, the
          // same way `previewWindow` is.
          final arguments = call.arguments;
          if (arguments is Map) {
            setState(() {
              _pendingAddedWindow = ProjectWindow.fromJson(
                arguments.map((key, value) => MapEntry(key.toString(), value)),
              );
              _addedWindowToken++;
            });
          }
        case 'allWindowsChanged':
          // Every screen's tiles changed somewhere — not necessarily this one, and
          // not necessarily *only* this one — so this only refreshes the "apps still
          // available" bookkeeping, and deliberately does not bump `_revision`: an
          // in-progress local drag/selection on this screen must survive another
          // screen's edit landing mid-gesture.
          setState(() => _allWindows = _decode(call.arguments, ProjectWindow.fromJson));
        case 'dragPreview':
          // A drag still in progress on another screen is hovering over this one —
          // no revision bump, same reasoning as `allWindowsChanged`: purely additive
          // visual state, not a real edit to this screen's own tiles.
          final arguments = call.arguments;
          if (arguments is Map) {
            setState(
              () => _previewWindow = ProjectWindow.fromJson(
                arguments.map((key, value) => MapEntry(key.toString(), value)),
              ),
            );
          }
        case 'hideDragPreview':
          setState(() => _previewWindow = null);
      }
      return null;
    });
  }

  void _read(Map<Object?, Object?> arguments) {
    _allScreens = _decode(arguments['screens'], ScreenInfo.fromJson);
    final screenIndex = (arguments['screenIndex'] as num?)?.toInt();
    _screen = _allScreens.where((screen) => screen.index == screenIndex).firstOrNull;
    _windows = _decode(arguments['windows'], ProjectWindow.fromJson);
    _allWindows = _decode(arguments['allWindows'], ProjectWindow.fromJson);
    _library = _decode(arguments['library'], AppLibraryEntry.fromJson);

    final icons = arguments['icons'];
    _icons = icons is Map
        ? {
            for (final entry in icons.entries)
              if (entry.value case final Uint8List bytes) entry.key.toString(): bytes,
          }
        : const {};
  }

  /// Method-channel maps arrive as `Map<Object?, Object?>`; the generated codecs want
  /// `Map<String, dynamic>`.
  List<T> _decode<T>(Object? raw, T Function(Map<String, dynamic> json) fromJson) => raw is List
      ? [
          for (final entry in raw.whereType<Map<Object?, Object?>>())
            fromJson(entry.map((key, value) => MapEntry(key.toString(), value))),
        ]
      : const [];

  /// Tells native this screen's current tiles, so a merge is ready the moment any
  /// screen's "apply" is pressed. Every local edit calls this — not just the final
  /// one — since there is no other way for native (or any other screen) to know this
  /// isolate's state.
  void _notifyChanged(List<ProjectWindow> windows) {
    final screen = _screen;
    if (screen == null) return;
    _channel.invokeMethod<void>('windowsChanged', {
      'screenIndex': screen.index,
      'windows': [for (final window in windows) window.toJson()],
    });
  }

  void _moveToOtherScreen(ProjectWindow window, int targetScreenIndex) => _channel.invokeMethod<void>(
    'moveWindowToScreen',
    {'window': window.copyWith(screenIndex: targetScreenIndex).toJson(), 'targetScreenIndex': targetScreenIndex},
  );

  void _showDragPreview(ProjectWindow window, int targetScreenIndex) => _channel.invokeMethod<void>(
    'showDragPreview',
    {'window': window.toJson(), 'targetScreenIndex': targetScreenIndex},
  );

  void _hideDragPreview(int targetScreenIndex) =>
      _channel.invokeMethod<void>('hideDragPreview', {'targetScreenIndex': targetScreenIndex});

  @override
  Widget build(BuildContext context) {
    final screen = _screen;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: const UiTheme().lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // A transparent Scaffold: it is the Material ancestor anything below expects, and
      // it must not paint a background of its own or the desktop would be covered.
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: screen == null
            // Nothing to arrange yet — the payload follows within a frame or two.
            ? const SizedBox.shrink()
            : LayoutOverlayScreen(
                key: ValueKey(_revision),
                screen: screen,
                allScreens: _allScreens,
                windows: _windows,
                allWindows: _allWindows,
                onWindowsChanged: _notifyChanged,
                onMoveToOtherScreen: _moveToOtherScreen,
                onDragPreview: _showDragPreview,
                onHideDragPreview: _hideDragPreview,
                library: _library,
                icons: _icons,
                previewWindow: _previewWindow,
                pendingAddedWindow: _pendingAddedWindow,
                addedWindowToken: _addedWindowToken,
                onApply: () => _channel.invokeMethod<void>('apply'),
                onCancel: () => _channel.invokeMethod<void>('cancel'),
              ),
      ),
    );
  }
}
