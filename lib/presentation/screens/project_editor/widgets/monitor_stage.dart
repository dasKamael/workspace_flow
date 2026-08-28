import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/snap_guide.painter.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

/// The monitor stage: one 16:10 bezel per attached display, side by side, with the
/// window tiles positioned in percent inside them.
///
/// The stage owns all the drag maths. It records the rectangle a drag started from and
/// derives every frame from the *original* rect plus the total pointer travel, so a
/// tile follows the pointer exactly and lets go of a magnet again instead of sticking
/// to it. It is also the only widget that knows the monitor sizes and can say which
/// display the pointer is currently over.
class MonitorStage extends StatefulWidget {
  const MonitorStage({
    required this.screens,
    required this.windows,
    required this.selectedIndex,
    required this.guidesX,
    required this.guidesY,
    required this.draggingIndex,
    required this.onSelect,
    required this.onRemove,
    required this.onPlace,
    required this.onMove,
    required this.onResize,
    required this.onDragEnd,
    super.key,
  });

  final List<ScreenInfo> screens;
  final List<ProjectWindow> windows;
  final int? selectedIndex;

  /// Percent positions of the guides to draw, and which monitor to draw them on.
  final List<double> guidesX;
  final List<double> guidesY;
  final int? draggingIndex;

  final ValueChanged<int?> onSelect;
  final ValueChanged<int> onRemove;

  /// A chip was dropped: place it at a percentage position on a monitor.
  final void Function({required AppLibraryEntry entry, required int screenIndex, required double x, required double y})
  onPlace;

  /// A raw target position for a tile, possibly on a different monitor.
  final void Function({
    required int index,
    required int screenIndex,
    required double x,
    required double y,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  })
  onMove;

  /// Cumulative resize deltas in percent, measured from the drag origin.
  final void Function({
    required int index,
    required ResizeHandle handle,
    required double deltaX,
    required double deltaY,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  })
  onResize;

  final VoidCallback onDragEnd;

  @override
  State<MonitorStage> createState() => _MonitorStageState();
}

/// What a running drag needs to remember.
///
/// [origin] is the tile as it was when the drag started; every update is computed from
/// it, never from the value written in the meantime.
typedef _DragSession = ({int index, ProjectWindow origin, Offset pointerStart, ResizeHandle? handle});

class _MonitorStageState extends State<MonitorStage> {
  /// One key per monitor, so a drag can ask which display it is over. Kept in the
  /// state rather than statically — otherwise every stage would share the same keys.
  final Map<int, GlobalKey> _monitorKeys = {};

  _DragSession? _session;

  GlobalKey _keyFor(int index) => _monitorKeys.putIfAbsent(index, GlobalKey.new);

  /// Holding option suspends magnetism for fine positioning.
  bool get _magnetsEnabled => !HardwareKeyboard.instance.isAltPressed;

  /// The monitor under [globalPosition], or null when the pointer is outside all of
  /// them — which is how a tile gets removed by dropping it away from the stage.
  int? _monitorAt(Offset globalPosition) {
    for (var index = 0; index < widget.screens.length; index++) {
      final box = _monitorKeys[index]?.currentContext?.findRenderObject();
      if (box is! RenderBox) continue;
      final local = box.globalToLocal(globalPosition);
      if (local.dx >= 0 && local.dy >= 0 && local.dx <= box.size.width && local.dy <= box.size.height) return index;
    }
    return null;
  }

  /// Percentage position of [globalPosition] inside monitor [index].
  Offset? _percentAt(int index, Offset globalPosition) {
    final box = _monitorKeys[index]?.currentContext?.findRenderObject();
    if (box is! RenderBox) return null;
    final local = box.globalToLocal(globalPosition);
    return Offset(local.dx / box.size.width * 100, local.dy / box.size.height * 100);
  }

  /// Size in logical pixels of monitor [index], to convert pointer travel into percent.
  Size? _sizeOf(int index) {
    final box = _monitorKeys[index]?.currentContext?.findRenderObject();
    return box is RenderBox ? box.size : null;
  }

  void _startDrag(int index, Offset globalPosition, {ResizeHandle? handle}) {
    final window = widget.windows.elementAtOrNull(index);
    if (window == null) return;
    _session = (index: index, origin: window, pointerStart: globalPosition, handle: handle);
  }

  void _updateMove(Offset globalPosition) {
    final session = _session;
    if (session == null || session.handle != null) return;

    // The monitor under the pointer wins, so a tile can cross displays mid-drag.
    final target = _monitorAt(globalPosition) ?? session.origin.screenIndex;
    final size = _sizeOf(target);
    if (size == null) return;

    final travel = globalPosition - session.pointerStart;
    widget.onMove(
      index: session.index,
      screenIndex: target,
      x: session.origin.x + travel.dx / size.width * 100,
      y: session.origin.y + travel.dy / size.height * 100,
      origin: session.origin,
      magnetsEnabled: _magnetsEnabled,
    );
  }

  void _updateResize(Offset globalPosition) {
    final session = _session;
    final handle = session?.handle;
    if (session == null || handle == null) return;

    final size = _sizeOf(session.origin.screenIndex);
    if (size == null) return;

    final travel = globalPosition - session.pointerStart;
    widget.onResize(
      index: session.index,
      handle: handle,
      deltaX: travel.dx / size.width * 100,
      deltaY: travel.dy / size.height * 100,
      origin: session.origin,
      magnetsEnabled: _magnetsEnabled,
    );
  }

  void _endDrag(Offset? globalPosition) {
    final session = _session;
    _session = null;
    widget.onDragEnd();

    // Dropped away from every monitor — that removes the tile.
    if (session != null && session.handle == null && globalPosition != null && _monitorAt(globalPosition) == null) {
      widget.onRemove(session.index);
    }
  }

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (final (index, screen) in widget.screens.indexed) ...[
        if (index > 0) UiSpacer.m,
        Expanded(
          // Wider displays get proportionally more of the row.
          flex: (screen.visibleWidth / 1000).clamp(1.0, 4.0).round() * 10,
          child: _Monitor(
            monitorKey: _keyFor(index),
            screen: screen,
            index: index,
            windows: widget.windows,
            selectedIndex: widget.selectedIndex,
            guidesX: _showGuidesOn(index) ? widget.guidesX : const [],
            guidesY: _showGuidesOn(index) ? widget.guidesY : const [],
            onSelect: widget.onSelect,
            onRemove: widget.onRemove,
            onPlace: (entry, globalPosition) {
              final percent = _percentAt(index, globalPosition);
              if (percent == null) return;
              widget.onPlace(entry: entry, screenIndex: index, x: percent.dx, y: percent.dy);
            },
            onDragStart: (tileIndex, position) => _startDrag(tileIndex, position),
            onDragUpdate: _updateMove,
            onDragEnd: _endDrag,
            onResizeStart: (tileIndex, handle, position) => _startDrag(tileIndex, position, handle: handle),
            onResizeUpdate: _updateResize,
            onResizeEnd: () => _endDrag(null),
          ),
        ),
      ],
    ],
  );

  /// Guides belong on the monitor the dragged tile currently lives on.
  bool _showGuidesOn(int index) {
    final dragging = widget.draggingIndex;
    if (dragging == null) return false;
    return widget.windows.elementAtOrNull(dragging)?.screenIndex == index;
  }
}

class _Monitor extends StatelessWidget {
  const _Monitor({
    required this.monitorKey,
    required this.screen,
    required this.index,
    required this.windows,
    required this.selectedIndex,
    required this.guidesX,
    required this.guidesY,
    required this.onSelect,
    required this.onRemove,
    required this.onPlace,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onResizeStart,
    required this.onResizeUpdate,
    required this.onResizeEnd,
  });

  final GlobalKey monitorKey;
  final ScreenInfo screen;
  final int index;
  final List<ProjectWindow> windows;
  final int? selectedIndex;
  final List<double> guidesX;
  final List<double> guidesY;

  final ValueChanged<int?> onSelect;
  final ValueChanged<int> onRemove;
  final void Function(AppLibraryEntry entry, Offset globalPosition) onPlace;

  final void Function(int index, Offset globalPosition) onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;

  final void Function(int index, ResizeHandle handle, Offset globalPosition) onResizeStart;
  final ValueChanged<Offset> onResizeUpdate;
  final VoidCallback onResizeEnd;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      AspectRatio(
        aspectRatio: 16 / 10,
        child: DragTarget<AppLibraryEntry>(
          onAcceptWithDetails: (details) => onPlace(details.data, details.offset),
          builder: (context, candidate, _) => Container(
            key: monitorKey,
            decoration: BoxDecoration(
              color: candidate.isEmpty ? UiColor.bgSubtle : UiColor.bgAccent,
              borderRadius: UiRadius.allL,
              border: Border.all(color: UiColor.bgDark, width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  for (final (windowIndex, window) in windows.indexed)
                    if (window.screenIndex == index)
                      Positioned(
                        left: constraints.maxWidth * window.x / 100,
                        top: constraints.maxHeight * window.y / 100,
                        width: constraints.maxWidth * window.width / 100,
                        height: constraints.maxHeight * window.height / 100,
                        child: WindowTile(
                          window: window,
                          isSelected: windowIndex == selectedIndex,
                          onSelect: () => onSelect(windowIndex),
                          onRemove: () => onRemove(windowIndex),
                          onDragStart: (position) => onDragStart(windowIndex, position),
                          onDragUpdate: onDragUpdate,
                          onDragEnd: onDragEnd,
                          onResizeStart: (handle, position) => onResizeStart(windowIndex, handle, position),
                          onResizeUpdate: onResizeUpdate,
                          onResizeEnd: onResizeEnd,
                        ),
                      ),
                  if (guidesX.isNotEmpty || guidesY.isNotEmpty)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: SnapGuidePainter(guidesX: guidesX, guidesY: guidesY),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      UiSpacer.xs,
      Text(
        context.translations.project_editor_monitor_caption(index + 1, screen.diagonalLabel),
        style: UiTypography.monitorCaption,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: UiSize.xxs),
    ],
  );
}
