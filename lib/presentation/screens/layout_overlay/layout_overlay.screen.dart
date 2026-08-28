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

/// Arranges a layout at full size on the real screens.
///
/// Rendered by a second Flutter engine in a borderless window spanning every display,
/// so a tile sits exactly where — and is exactly as big as — the window will be after a
/// launch. Same tiles, same magnets, same guides as the miniature stage in the editor;
/// only the scale differs, and the size readout switches to real points.
class LayoutOverlayScreen extends StatefulWidget {
  const LayoutOverlayScreen({
    required this.screens,
    required this.initialWindows,
    required this.onApply,
    required this.onCancel,
    this.library = const [],
    this.icons = const {},
    super.key,
  });

  final List<ScreenInfo> screens;
  final List<ProjectWindow> initialWindows;

  /// Apps that can still be dropped onto a screen. Everything already in the layout is
  /// left out, so the row only ever shows what is actually addable.
  final List<AppLibraryEntry> library;

  /// App icons by bundle id, fetched by the main engine and passed in with the payload.
  final Map<String, Uint8List> icons;

  final ValueChanged<List<ProjectWindow>> onApply;
  final VoidCallback onCancel;

  @override
  State<LayoutOverlayScreen> createState() => _LayoutOverlayScreenState();
}

class _LayoutOverlayScreenState extends State<LayoutOverlayScreen> with WindowDragHandling {
  late final List<ProjectWindow> _windows = [...widget.initialWindows];

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

  /// Top-left corner of the union of all screens: the overlay window's own origin,
  /// which every screen rectangle is measured against.
  late final Offset _origin = Offset(
    widget.screens.map((screen) => screen.visibleX).reduce((a, b) => a < b ? a : b),
    widget.screens.map((screen) => screen.visibleY).reduce((a, b) => a < b ? a : b),
  );

  /// Where a screen sits inside the overlay, in logical pixels.
  ///
  /// The Flutter view fills the borderless window and the window's origin *is* the
  /// union of all screens, so these rectangles are also the global coordinates the
  /// drag handling reports — no conversion needed.
  Rect _rectOf(ScreenInfo screen) => Rect.fromLTWH(
    screen.visibleX - _origin.dx,
    screen.visibleY - _origin.dy,
    screen.visibleWidth,
    screen.visibleHeight,
  );

  ScreenInfo? _screenAt(int index) => widget.screens.where((screen) => screen.index == index).firstOrNull;

  // ---------------------------------------------------------- drag handling
  @override
  int? monitorAt(Offset globalPosition) {
    for (final screen in widget.screens) {
      if (_rectOf(screen).contains(globalPosition)) return screen.index;
    }
    return null;
  }

  @override
  Size? monitorSizeOf(int screenIndex) {
    final screen = _screenAt(screenIndex);
    return screen == null ? null : Size(screen.visibleWidth, screen.visibleHeight);
  }

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
    final snap = WindowSnapUtil.snapMove(
      moving: origin.copyWith(screenIndex: screenIndex),
      neighbours: _windows,
      x: x,
      y: y,
      magnetsEnabled: magnetsEnabled,
    );

    _patch(
      index,
      (window) => window.copyWith(screenIndex: screenIndex, x: snap.x, y: snap.y),
      snap: snap,
    );
  }

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
  void reportDragEnd() => setState(() {
    _draggingIndex = null;
    _guidesX = const [];
    _guidesY = const [];
  });

  @override
  void reportRemove(int index) => setState(() {
    _windows.removeAt(index);
    _selectedIndex = null;
  });

  /// Drops [entry] onto [screenIndex] at a percentage position.
  void _place(AppLibraryEntry entry, int screenIndex, Offset percent) => setState(() {
    _windows.add(
      ProjectWindow.fromDrop(
        // Negative, like every other draft tile, so it cannot collide with a stored row.
        id: -(_windows.length + 1),
        name: entry.name,
        bundleId: entry.bundleId,
        url: entry.url,
        documentPath: entry.documentPath,
        screenIndex: screenIndex,
        x: percent.dx,
        y: percent.dy,
      ),
    );
    _selectedIndex = _windows.length - 1;
  });

  /// The identities already in the layout, so their chips drop out of the row.
  ///
  /// Matches [AppLibraryEntry.key] so two project variants of the same app — sharing a
  /// bundle id but naming different folders — hide independently of one another.
  Set<String> get _placedKeys => {for (final window in _windows) window.libraryKey};

  void _patch(int index, ProjectWindow Function(ProjectWindow window) patch, {required WindowSnap snap}) {
    if (index < 0 || index >= _windows.length) return;
    setState(() {
      _windows[index] = patch(_windows[index]);
      _draggingIndex = index;
      _guidesX = snap.guidesX;
      _guidesY = snap.guidesY;
    });
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
      actions: {
        _CancelIntent: CallbackAction<_CancelIntent>(onInvoke: (_) => widget.onCancel()),
        _ApplyIntent: CallbackAction<_ApplyIntent>(onInvoke: (_) => widget.onApply(_windows)),
      },
      child: Focus(
        autofocus: true,
        child: ColoredBox(
          // The real desktop stays visible behind a dark veil, so the screen edges and
          // the surrounding context still read while the tiles stand out.
          color: UiColor.scrim,
          child: Stack(
            children: [
              for (final screen in widget.screens) ..._screenLayer(screen),
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
                    onApply: () => widget.onApply(_windows),
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

  /// Percentage position of a global point inside [rect].
  Offset _percentIn(Rect rect, Offset globalPosition) =>
      Offset((globalPosition.dx - rect.left) / rect.width * 100, (globalPosition.dy - rect.top) / rect.height * 100);

  /// One screen: its outline, its caption, its tiles, and the guides of a drag on it.
  List<Widget> _screenLayer(ScreenInfo screen) {
    final rect = _rectOf(screen);
    final isDragTarget =
        _draggingIndex != null && _windows.elementAtOrNull(_draggingIndex!)?.screenIndex == screen.index;

    return [
      Positioned.fromRect(
        rect: rect,
        child: DragTarget<AppLibraryEntry>(
          // Opaque, or only the caption in the corner would catch a drop: the outline
          // itself paints nothing and would defer the hit test to its only child.
          hitTestBehavior: HitTestBehavior.opaque,
          onAcceptWithDetails: (details) => _place(details.data, screen.index, _percentIn(rect, details.offset)),
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
                  context.translations.project_editor_monitor_caption(screen.index + 1, screen.diagonalLabel),
                  style: UiTypography.monitorCaption.copyWith(color: UiColor.onDarkMuted),
                ),
              ),
            ),
          ),
        ),
      ),
      for (final (index, window) in _windows.indexed)
        if (window.screenIndex == screen.index)
          Positioned(
            left: rect.left + rect.width * window.x / 100,
            top: rect.top + rect.height * window.y / 100,
            width: rect.width * window.width / 100,
            height: rect.height * window.height / 100,
            child: IgnorePointer(
              ignoring: _isPlacing,
              child: WindowTile(
                window: window,
                // Real points, not percentages — the reason for arranging at full size.
                sizeLabel: context.translations.project_editor_tile_size(
                  (screen.visibleWidth * window.width / 100).round().toString(),
                  (screen.visibleHeight * window.height / 100).round().toString(),
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
      if (isDragTarget && (_guidesX.isNotEmpty || _guidesY.isNotEmpty))
        Positioned.fromRect(
          rect: rect,
          child: IgnorePointer(
            child: CustomPaint(
              painter: SnapGuidePainter(guidesX: _guidesX, guidesY: _guidesY),
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
