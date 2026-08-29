import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace_flow/common/translation/app_localizations.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/design_system/ui_theme.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.screen.dart';

/// The app rendered by the layout-overlay engine.
///
/// Like the blocked page it runs in its own isolate with no provider container:
/// the draft arrives over [_channel] and the edited layout goes back the same way.
class LayoutOverlayApp extends StatefulWidget {
  const LayoutOverlayApp({super.key});

  @override
  State<LayoutOverlayApp> createState() => _LayoutOverlayAppState();
}

class _LayoutOverlayAppState extends State<LayoutOverlayApp> {
  static const MethodChannel _channel = MethodChannel('de.coodoo.workspace_flow/layout_overlay');

  List<ScreenInfo> _screens = const [];
  List<ProjectWindow> _windows = const [];
  List<AppLibraryEntry> _library = const [];
  Map<String, Uint8List> _icons = const {};

  /// Bumped on every `update`, and used as [LayoutOverlayScreen]'s key.
  ///
  /// The overlay window and its engine are reused across separate "Arrange on
  /// screen" sessions rather than recreated, so without a changing key Flutter
  /// would treat each `update` as a mere prop change to the *same* element —
  /// leaving `_LayoutOverlayScreenState`'s `late final _windows` (copied from
  /// `widget.initialWindows` exactly once) stuck on whichever project's windows
  /// happened to be the first ever shown this session.
  int _revision = 0;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'update') return null;
      final arguments = call.arguments;
      if (arguments is Map) {
        setState(() {
          _read(arguments);
          _revision++;
        });
      }
      return null;
    });
  }

  void _read(Map<Object?, Object?> arguments) {
    _screens = _decode(arguments['screens'], ScreenInfo.fromJson);
    _windows = _decode(arguments['windows'], ProjectWindow.fromJson);
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

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: const UiTheme().lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // A transparent Scaffold: it is the Material ancestor anything below expects, and
    // it must not paint a background of its own or the desktop would be covered.
    home: Scaffold(
      backgroundColor: Colors.transparent,
      body: _screens.isEmpty
          // Nothing to arrange yet — the payload follows within a frame or two.
          ? const SizedBox.shrink()
          : LayoutOverlayScreen(
              key: ValueKey(_revision),
              screens: _screens,
              initialWindows: _windows,
              library: _library,
              icons: _icons,
              onApply: (windows) => _channel.invokeMethod<void>('apply', {
                'windows': [for (final window in windows) window.toJson()],
              }),
              onCancel: () => _channel.invokeMethod<void>('cancel'),
            ),
    ),
  );
}
