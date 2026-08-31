import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/project/model/window_snap.dart';
import 'package:workspace_flow/domain/project/window_snap.util.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/snap_guide.painter.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_drag_handling.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

/// One physical screen's own "arrange a layout at full size on the real screens" —
/// one instance per screen, each hosted by its own native window *and* its own
/// engine/isolate (see `LayoutOverlayService.swift` for why one engine can't serve
/// more than one screen here).
///
/// Because each screen is its own isolate, [windows] is only ever *this* screen's own
/// tiles, and this widget owns that list itself exactly the way a single-screen
/// overlay always did — there is no shared list to lift up to a parent this time.
/// [onWindowsChanged] still fires on every edit, but now it's telling native to keep
/// its cross-screen bookkeeping fresh, not asking a Dart parent to hold the truth.
class LayoutOverlayScreen extends StatefulWidget {
  const LayoutOverlayScreen({
    required this.screen,
    required this.allScreens,
    required this.windows,
    required this.allWindows,
    required this.onWindowsChanged,
    required this.onMoveToOtherScreen,
    required this.onDragPreview,
    required this.onHideDragPreview,
    required this.onApply,
    required this.onCancel,
    this.library = const [],
    this.icons = const {},
    this.previewWindow,
    this.pendingAddedWindow,
    this.addedWindowToken = 0,
    super.key,
  });

  /// Which physical screen this instance renders.
  final ScreenInfo screen;

  /// Every attached screen, with their own geometry — used to work out which screen
  /// a tile dragged out of this one's bounds actually landed on (see
  /// [WindowDragHandling.reportDroppedOutside]), live, while it's still in progress
  /// (see [onDragPreview]).
  final List<ScreenInfo> allScreens;

  /// The initial tiles for this screen; copied into local state once and owned here
  /// after that, same as a single-screen overlay always worked.
  final List<ProjectWindow> windows;

  /// Every screen's tiles, kept current by native but always a beat behind this
  /// screen's own [windows] for anything just edited here — used only to keep the
  /// "apps still available" row honest across screens, never to decide what renders.
  final List<ProjectWindow> allWindows;

  /// Called after every local edit with this screen's full current tile list, so
  /// native can keep a fresh copy ready for the moment "apply" is pressed on any
  /// screen.
  final ValueChanged<List<ProjectWindow>> onWindowsChanged;

  /// Moves [ProjectWindow] to another screen once a drag whose drop point
  /// [reportDroppedOutside] resolved onto a different screen actually ends. A live
  /// drag itself can never cross into a different screen's own window — AppKit only
  /// ever delivers a captured drag's events to the window it started in — which is
  /// why [onDragPreview] exists to at least show where it's headed before it does.
  final void Function(ProjectWindow window, int targetScreenIndex) onMoveToOtherScreen;

  /// While a drag on this screen is hovering over [targetScreenIndex]'s physical
  /// area, this is a live preview of where [window] would land there if released
  /// right now — sent continuously as the drag moves, purely so that *other* screen
  /// can show a ghost of it while the drag is still in progress. Nothing is actually
  /// moved until the drag ends; see [onMoveToOtherScreen] for that.
  final void Function(ProjectWindow window, int targetScreenIndex) onDragPreview;

  /// The drag that was showing a preview on [targetScreenIndex] no longer is —
  /// either it moved back over this screen, ended, or landed somewhere no screen
  /// occupies.
  final ValueChanged<int> onHideDragPreview;

  /// Apps that can still be dropped onto a screen. Everything already in the layout —
  /// on *any* screen, via [allWindows] — is left out, so the row only ever shows what
  /// is actually addable.
  final List<AppLibraryEntry> library;

  /// App icons by bundle id, fetched by the main engine and passed in with the payload.
  final Map<String, Uint8List> icons;

  final VoidCallback onApply;
  final VoidCallback onCancel;

  /// A live preview pushed from another screen's own in-progress drag — see
  /// [onDragPreview]. Rendered as a non-interactive ghost, never part of [windows].
  final ProjectWindow? previewWindow;

  /// A tile another screen's drag just finished moving onto this one, paired with
  /// [addedWindowToken] so a *new* push can be told apart from the last one even if
  /// the window data happens to be identical. Folded into local state via
  /// `didUpdateWidget` when the token changes — never through [windows]/a new `key`,
  /// which would recreate this screen's state and re-seed it from [windows] as it
  /// was at the *start* of the session, silently undoing every local edit (a
  /// removal, especially) made since.
  final ProjectWindow? pendingAddedWindow;
  final int addedWindowToken;

  @override
  State<LayoutOverlayScreen> createState() => _LayoutOverlayScreenState();
}

class _LayoutOverlayScreenState extends State<LayoutOverlayScreen> with WindowDragHandling {
  late final List<ProjectWindow> _windows = [...widget.windows];

  /// The last [LayoutOverlayScreen.addedWindowToken] already folded into
  /// [_windows], so [didUpdateWidget] only reacts to a token it hasn't seen yet.
  ///
  /// Set in [initState], not as a `late` field initializer: this is never read
  /// during [build], so a `late` initializer would only ever run on its first
  /// access — inside [didUpdateWidget] itself — by which point `widget` already
  /// *is* the new one, making every comparison trivially equal and silently
  /// skipping every push.
  int _lastAddedWindowToken = 0;

  int? _selectedIndex;
  int? _draggingIndex;

  /// True while an app is being dragged out of the library row.
  ///
  /// The tiles stop taking pointers for that moment: a tile lying under the cursor
  /// would otherwise shadow the screen's drop region and the app could only be
  /// dropped on empty space.
  bool _isPlacing = false;
  List<double> _guidesX = const [];
  List<double> _guidesY = const [];

  /// Which other screen, if any, the current drag is showing a live preview on —
  /// tracked so [reportDragEnd] knows whether there is one to hide.
  int? _previewTarget;

  /// The tile exactly as [_previewTarget]'s live preview last showed it — reused
  /// verbatim by [reportDroppedOutside] so it lands exactly there on release,
  /// rather than being recomputed centred on the cursor at that instant. The
  /// preview already tracks the pointer the same relative-motion way an ordinary
  /// same-screen drag does (see [reportMove]), so reusing it is what keeps the
  /// tile's position relative to the cursor continuous across the hand-off instead
  /// of jumping the moment the mouse button lifts.
  ProjectWindow? _previewedPlacement;

  @override
  void initState() {
    super.initState();
    _lastAddedWindowToken = widget.addedWindowToken;
  }

  @override
  void didUpdateWidget(LayoutOverlayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.addedWindowToken == _lastAddedWindowToken) return;
    _lastAddedWindowToken = widget.addedWindowToken;
    final added = widget.pendingAddedWindow;
    if (added == null) return;
    // Not reported back via `onWindowsChanged`: native already folded this same
    // tile into its own bookkeeping for this screen directly, the moment it
    // relayed `moveWindowToScreen` — this only has to make it render here too.
    setState(() => _windows.add(added));
  }

  /// This screen's own area, in logical pixels.
  ///
  /// The native window is already sized to exactly this screen's `visibleFrame`
  /// (unlike the old single-window overlay, which spanned every display and needed
  /// an offset into their union) — so this is just the window's own bounds, and it's
  /// also the global coordinate space the drag handling reports in directly.
  Rect get _ownRect => Rect.fromLTWH(0, 0, widget.screen.visibleWidth, widget.screen.visibleHeight);

  // ---------------------------------------------------------- drag handling
  @override
  int? monitorAt(Offset globalPosition) => _ownRect.contains(globalPosition) ? widget.screen.index : null;

  @override
  Size? monitorSizeOf(int screenIndex) =>
      screenIndex == widget.screen.index ? Size(widget.screen.visibleWidth, widget.screen.visibleHeight) : null;

  @override
  ProjectWindow? windowAt(int index) => _windows.elementAtOrNull(index);

  @override
  void reportMove({
    required int index,
    required int screenIndex,
    required double x,
    required double y,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  }) {
    // A drag can never actually leave this screen (see the class doc on
    // `onMoveToOtherScreen`), so `screenIndex` here is always this screen's own —
    // kept as a parameter only because the mixin is shared with the miniature stage.
    final snap = WindowSnapUtil.snapMove(
      moving: origin.copyWith(screenIndex: screenIndex),
      neighbours: _windows,
      x: x,
      y: y,
      magnetsEnabled: magnetsEnabled,
    );
    _patch(
      index,
      (window) =>
          window.copyWith(screenIndex: screenIndex, displayId: widget.screen.displayId, x: snap.x, y: snap.y),
      snap: snap,
    );
    // The *unsnapped* x/y, not `snap.x`/`snap.y`: `WindowSnapUtil.snapMove` clamps
    // to 0–100 so the tile itself doesn't visually fly off this screen while
    // dragging — exactly the range that never leaves this screen's own bounds, so
    // checking against the clamped value could never detect a cross-screen hover.
    _updateCrossScreenPreview(origin, x: x, y: y);
  }

  /// While a move-drag's raw, unsnapped position (can run past 0–100 the moment the
  /// pointer leaves this screen — see the class doc on [reportMove]'s `screenIndex`
  /// parameter) sits over a different attached screen's physical area, pushes a live
  /// preview of where it would land there. Cleared the instant it moves back over
  /// this screen, a gap between screens, or the drag ends.
  void _updateCrossScreenPreview(ProjectWindow origin, {required double x, required double y}) {
    final absolute = widget.screen.rectFromPercent(x: x, y: y, width: origin.width, height: origin.height);
    final target = _screenContaining(absolute.x + absolute.width / 2, absolute.y + absolute.height / 2);

    // The screen currently showing a preview changed — including jumping straight
    // from one non-origin screen to a *different* one, which a fast drag across 3+
    // monitors does easily (the point that was over screen 2 one frame can land on
    // screen 3 the next, with no frame ever landing in between). That previous
    // screen never otherwise hears about this: only ever telling the *new* target
    // would leave its ghost stuck there for good. Cleared unconditionally on any
    // change, then re-shown fresh if there's still a target at all.
    if (target?.index != _previewTarget) _clearPreview();
    if (target == null) return;

    final percent = target.percentFromRect(x: absolute.x, y: absolute.y, width: absolute.width, height: absolute.height);
    final placement = origin.copyWith(
      screenIndex: target.index,
      displayId: target.displayId,
      x: percent.x,
      y: percent.y,
      width: percent.width,
      height: percent.height,
    );
    widget.onDragPreview(placement, target.index);
    _previewTarget = target.index;
    _previewedPlacement = placement;
  }

  void _clearPreview() {
    final target = _previewTarget;
    if (target == null) return;
    widget.onHideDragPreview(target);
    _previewTarget = null;
    _previewedPlacement = null;
  }

  /// The other attached screen (never this one) whose physical area contains the
  /// shared-space point ([sharedX], [sharedY]) — the same lookup [reportDroppedOutside]
  /// uses to resolve a finished drag, reused here for the live preview mid-drag.
  ScreenInfo? _screenContaining(double sharedX, double sharedY) => widget.allScreens
      .where((screen) => screen.index != widget.screen.index)
      .where(
        (screen) =>
            sharedX >= screen.visibleX &&
            sharedX < screen.visibleX + screen.visibleWidth &&
            sharedY >= screen.visibleY &&
            sharedY < screen.visibleY + screen.visibleHeight,
      )
      .firstOrNull;

  @override
  void reportResize({
    required int index,
    required ResizeHandle handle,
    required double deltaX,
    required double deltaY,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  }) {
    final snap = WindowSnapUtil.snapResize(
      window: origin,
      handle: handle,
      deltaX: deltaX,
      deltaY: deltaY,
      neighbours: _windows,
      magnetsEnabled: magnetsEnabled,
    );
    _patch(
      index,
      (window) => window.copyWith(x: snap.x, y: snap.y, width: snap.width, height: snap.height),
      snap: snap,
    );
  }

  @override
  void reportDragEnd() {
    // Deliberately does *not* clear the live preview here, unlike an earlier
    // version of this method: the mixin calls this *before* `reportDroppedOutside`
    // (see `WindowDragHandling.endDrag`), so clearing unconditionally at this point
    // would wipe `_previewedPlacement` before that method ever gets to read it,
    // silently breaking every cross-screen commit. Every other case that actually
    // needs the preview gone already clears it reactively: moving back over this
    // screen or into a gap between screens both do, in `_updateCrossScreenPreview`
    // (`reportMove` fires for every move, in or out of bounds, so that transition
    // is never missed); a successful commit clears it itself, right after reading
    // it, in `reportDroppedOutside`.
    setState(() {
      _draggingIndex = null;
      _guidesX = const [];
      _guidesY = const [];
    });
  }

  @override
  void reportRemove(int index) {
    if (index < 0 || index >= _windows.length) return;
    setState(() {
      _windows.removeAt(index);
      _selectedIndex = null;
    });
    widget.onWindowsChanged(_windows);
  }

  /// Drops [entry] onto this screen at a percentage position.
  void _place(AppLibraryEntry entry, Offset percent) {
    setState(() {
      _windows.add(
        ProjectWindow.fromDrop(
          // Negative, like every other draft tile, so it cannot collide with a stored row.
          id: -(_windows.length + 1),
          name: entry.name,
          bundleId: entry.bundleId,
          url: entry.url,
          documentPath: entry.documentPath,
          screenIndex: widget.screen.index,
          displayId: widget.screen.displayId,
          x: percent.dx,
          y: percent.dy,
        ),
      );
      _selectedIndex = _windows.length - 1;
    });
    widget.onWindowsChanged(_windows);
  }

  /// Commits a drag that ended outside this screen's own bounds onto whichever
  /// *other* attached screen [_updateCrossScreenPreview] most recently found it
  /// hovering over — reusing that exact, already-computed placement (see
  /// [_previewedPlacement]) rather than recomputing one from [globalPosition] at
  /// this instant, which would centre the tile under the cursor and visibly jump it
  /// away from wherever it actually was a moment before release.
  @override
  bool reportDroppedOutside(int index, Offset globalPosition) {
    if (index < 0 || index >= _windows.length) return false;
    final placement = _previewedPlacement;
    if (placement == null) return false;
    // Consumed: the ghost this placement described is about to become a real tile
    // on the target screen instead, and this drag is over regardless either way.
    _clearPreview();

    setState(() {
      _windows.removeAt(index);
      _selectedIndex = null;
    });
    widget.onWindowsChanged(_windows);
    widget.onMoveToOtherScreen(placement, placement.screenIndex);
    return true;
  }

  /// The identities already in the layout on *any* screen, so their chips drop out
  /// of the row everywhere at once — not just on whichever screen they were placed on.
  ///
  /// Matches [AppLibraryEntry.key] so two project variants of the same app — sharing a
  /// bundle id but naming different folders — hide independently of one another.
  Set<String> get _placedKeys => {
    for (final window in _windows) window.libraryKey,
    for (final window in widget.allWindows) window.libraryKey,
  };

  void _patch(int index, ProjectWindow Function(ProjectWindow window) patch, {required WindowSnap snap}) {
    if (index < 0 || index >= _windows.length) return;
    setState(() {
      _windows[index] = patch(_windows[index]);
      _draggingIndex = index;
      _guidesX = snap.guidesX;
      _guidesY = snap.guidesY;
    });
    widget.onWindowsChanged(_windows);
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.escape): _CancelIntent(),
      SingleActivator(LogicalKeyboardKey.enter): _ApplyIntent(),
      SingleActivator(LogicalKeyboardKey.numpadEnter): _ApplyIntent(),
    },
    child: Actions(
      // Duplicated per screen rather than hoisted: each physical screen is its own
      // native window with independent AppKit key-window status, so esc/return only
      // ever reach whichever one currently has focus — every one of them needs its
      // own copy of these to be reachable at all.
      actions: {
        _CancelIntent: CallbackAction<_CancelIntent>(onInvoke: (_) => widget.onCancel()),
        _ApplyIntent: CallbackAction<_ApplyIntent>(onInvoke: (_) => widget.onApply()),
      },
      child: Focus(
        autofocus: true,
        child: ColoredBox(
          // The real desktop stays visible behind a dark veil, so the screen edges and
          // the surrounding context still read while the tiles stand out.
          color: UiColor.scrim,
          child: Stack(
            children: [
              ..._screenLayer(),
              // On every screen, not just the main one: an app can only ever be
              // dropped onto the screen whose own window it's dragged within — there
              // is no reaching across a screen boundary mid-drag (see the class doc
              // on `onMoveToOtherScreen`) — so each screen needs its own row to place
              // straight onto it, rather than placing on one screen and moving after.
              Positioned(
                left: 0,
                right: 0,
                bottom: UiSize.xxxl,
                child: Center(
                  child: _Toolbar(
                    available: widget.library.where((entry) => !_placedKeys.contains(entry.key)).toList(),
                    icons: widget.icons,
                    onDragStart: () => setState(() => _isPlacing = true),
                    onDragEnd: () => setState(() => _isPlacing = false),
                    onApply: widget.onApply,
                    onCancel: widget.onCancel,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Percentage position of a global point inside this screen.
  Offset _percentIn(Offset globalPosition) =>
      Offset(globalPosition.dx / _ownRect.width * 100, globalPosition.dy / _ownRect.height * 100);

  /// This screen: its outline, its caption, its tiles, and the guides of a drag on it.
  List<Widget> _screenLayer() {
    final rect = _ownRect;
    final isDragTarget = _draggingIndex != null;

    return [
      Positioned.fromRect(
        rect: rect,
        child: DragTarget<AppLibraryEntry>(
          // Opaque, or only the caption in the corner would catch a drop: the outline
          // itself paints nothing and would defer the hit test to its only child.
          hitTestBehavior: HitTestBehavior.opaque,
          onAcceptWithDetails: (details) => _place(details.data, _percentIn(details.offset)),
          builder: (context, candidate, _) => DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: candidate.isEmpty ? UiColor.borderOnDark : UiColor.accent, width: 2),
              color: candidate.isEmpty ? null : UiColor.accent.withValues(alpha: 0.08),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(UiSize.m),
                child: Text(
                  context.translations.project_editor_monitor_caption(
                    widget.screen.index + 1,
                    widget.screen.diagonalLabel,
                  ),
                  style: UiTypography.monitorCaption.copyWith(color: UiColor.onDarkMuted),
                ),
              ),
            ),
          ),
        ),
      ),
      // Every entry here should already belong to this screen — each edit only ever
      // touches this isolate's own list — but the filter stays as a cheap guard
      // against a stray `windowAdded` push carrying the wrong `screenIndex`.
      for (final (index, window) in _windows.indexed)
        if (window.screenIndex == widget.screen.index)
          Positioned(
            left: rect.width * window.x / 100,
            top: rect.height * window.y / 100,
            width: rect.width * window.width / 100,
            height: rect.height * window.height / 100,
            child: IgnorePointer(
              ignoring: _isPlacing,
              // `WindowSnapUtil.snapMove` clamps to 0–100, so without this the real
              // tile just sits stuck at this screen's edge — looking left behind —
              // for as long as a live preview shows it already sitting on another
              // screen instead. Opacity only, not `Visibility`/removal: the drag
              // this very tile is mid-way through has to keep receiving events from
              // the same `WindowTile` regardless of whether it's currently visible.
              child: Opacity(
                opacity: index == _draggingIndex && _previewTarget != null ? 0 : 1,
                child: WindowTile(
                  window: window,
                  // Real points, not percentages — the reason for arranging at full size.
                  sizeLabel: context.translations.project_editor_tile_size(
                    (widget.screen.visibleWidth * window.width / 100).round().toString(),
                    (widget.screen.visibleHeight * window.height / 100).round().toString(),
                  ),
                  icon: widget.icons[window.bundleId],
                  onDark: true,
                  isSelected: index == _selectedIndex,
                  onSelect: () => setState(() => _selectedIndex = index),
                  onRemove: () => reportRemove(index),
                  onDragStart: (position) => startDrag(index, position),
                  onDragUpdate: updateMove,
                  onDragEnd: endDrag,
                  onResizeStart: (handle, position) => startDrag(index, position, handle: handle),
                  onResizeUpdate: updateResize,
                  onResizeEnd: () => endDrag(null),
                ),
              ),
            ),
          ),
      if (isDragTarget && (_guidesX.isNotEmpty || _guidesY.isNotEmpty))
        Positioned.fromRect(
          rect: rect,
          child: IgnorePointer(
            child: CustomPaint(
              painter: SnapGuidePainter(guidesX: _guidesX, guidesY: _guidesY),
            ),
          ),
        ),
      // A live preview pushed from another screen's own in-progress drag — see the
      // class doc on `onDragPreview`. Faded and non-interactive: nothing has actually
      // landed here yet.
      if (widget.previewWindow case final preview?)
        Positioned(
          left: rect.width * preview.x / 100,
          top: rect.height * preview.y / 100,
          width: rect.width * preview.width / 100,
          height: rect.height * preview.height / 100,
          child: IgnorePointer(
            child: Opacity(
              opacity: 0.5,
              child: WindowTile(
                window: preview,
                sizeLabel: context.translations.project_editor_tile_size(
                  (widget.screen.visibleWidth * preview.width / 100).round().toString(),
                  (widget.screen.visibleHeight * preview.height / 100).round().toString(),
                ),
                icon: widget.icons[preview.bundleId],
                onDark: true,
                isSelected: false,
                onSelect: () {},
                onRemove: () {},
                onDragStart: (_) {},
                onDragUpdate: (_) {},
                onDragEnd: (_) {},
                onResizeStart: (_, _) {},
                onResizeUpdate: (_) {},
                onResizeEnd: () {},
              ),
            ),
          ),
        ),
    ];
  }
}

class _CancelIntent extends Intent {
  const _CancelIntent();
}

class _ApplyIntent extends Intent {
  const _ApplyIntent();
}

/// The floating bar: the apps still available, the hint, and the two actions.
///
/// The keyboard shortcuts do the same, but they have to be discoverable.
class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.available,
    required this.icons,
    required this.onApply,
    required this.onCancel,
    required this.onDragStart,
    required this.onDragEnd,
  });

  final List<AppLibraryEntry> available;
  final Map<String, Uint8List> icons;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  /// Widest the row of apps gets before it wraps onto another line.
  static const double maxLibraryWidth = 720;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: UiSize.xl, vertical: UiSize.ml),
    decoration: BoxDecoration(
      color: UiColor.bgDark,
      borderRadius: UiRadius.allXxl,
      border: Border.all(color: UiColor.borderOnDark),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (available.isNotEmpty) ...[
          Text(
            context.translations.layout_overlay_library_label.toUpperCase(),
            style: UiTypography.cardLabel.copyWith(color: UiColor.onDarkAccent),
          ),
          UiSpacer.s,
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxLibraryWidth),
            // Wrapped rather than scrolled: a horizontal scroller would win the gesture
            // arena against the chips and they could never be dragged out of the row.
            child: Wrap(
              spacing: UiSize.l,
              runSpacing: UiSize.m,
              children: [
                for (final entry in available)
                  _LibraryChip(
                    entry: entry,
                    icon: icons[entry.bundleId],
                    onDragStart: onDragStart,
                    onDragEnd: onDragEnd,
                  ),
              ],
            ),
          ),
          UiSpacer.ml,
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.translations.layout_overlay_hint,
              style: UiTypography.dialMeta.copyWith(color: UiColor.onDarkMuted),
            ),
            UiSpacer.xl,
            UiGhostButton(label: context.translations.common_cancel, onDark: true, onPressed: onCancel),
            UiSpacer.sm,
            UiPrimaryButton(label: context.translations.layout_overlay_save, onPressed: onApply),
          ],
        ),
      ],
    ),
  );
}

/// One draggable app in the overlay's row: its real icon with the name beneath.
///
/// Icons rather than labelled pills — at full size the row sits next to windows that
/// already carry the same icon, so the two read as the same thing.
class _LibraryChip extends StatelessWidget {
  const _LibraryChip({required this.entry, required this.onDragStart, required this.onDragEnd, this.icon});

  final AppLibraryEntry entry;
  final Uint8List? icon;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  static const double iconSize = 44;
  static const double labelWidth = 76;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon == null
            ? _IconPlaceholder(name: entry.name)
            : Image.memory(icon!, width: iconSize, height: iconSize, filterQuality: FilterQuality.medium),
        UiSpacer.xs,
        SizedBox(
          width: labelWidth,
          child: Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: UiTypography.tileSize.copyWith(color: UiColor.onDarkStrong),
          ),
        ),
      ],
    );

    return Draggable<AppLibraryEntry>(
      data: entry,
      onDragStarted: onDragStart,
      onDragEnd: (_) => onDragEnd(),
      onDraggableCanceled: (_, _) => onDragEnd(),
      feedback: Material(color: const Color(0x00000000), child: content),
      childWhenDragging: Opacity(opacity: 0.35, child: content),
      child: MouseRegion(cursor: SystemMouseCursors.grab, child: content),
    );
  }
}

/// Stands in for an app whose icon could not be read, and for websites, which have
/// none — the row stays evenly spaced either way.
class _IconPlaceholder extends StatelessWidget {
  const _IconPlaceholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => Container(
    width: _LibraryChip.iconSize,
    height: _LibraryChip.iconSize,
    decoration: BoxDecoration(
      color: UiColor.white.withValues(alpha: 0.12),
      borderRadius: UiRadius.allXl,
      border: Border.all(color: UiColor.borderOnDark),
    ),
    child: Center(
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: UiTypography.itemTitle.copyWith(color: UiColor.onDarkStrong),
      ),
    ),
  );
}
