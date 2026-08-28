import 'package:flutter/widgets.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_shadow.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// One window inside a monitor stage.
///
/// The tile does no geometry of its own: it reports raw pointer positions and lets the
/// stage work out percentages, magnets and which monitor the pointer is over. Only the
/// stage knows the monitor sizes, and keeping the maths in one place is what lets a
/// drag be computed from its origin instead of accumulating frame by frame.
class WindowTile extends StatelessWidget {
  const WindowTile({
    required this.window,
    required this.isSelected,
    required this.onSelect,
    required this.onRemove,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onResizeStart,
    required this.onResizeUpdate,
    required this.onResizeEnd,
    super.key,
  });

  final ProjectWindow window;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;

  final void Function(ResizeHandle handle, Offset globalPosition) onResizeStart;
  final ValueChanged<Offset> onResizeUpdate;
  final VoidCallback onResizeEnd;

  /// Edge length of a corner grip, as in the design.
  static const double cornerHandleSize = 14;

  /// Thickness of the invisible hit strips along the four sides.
  static const double edgeHandleThickness = 6;

  static const double closeSize = 18;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onSelect,
    onPanStart: (details) {
      onSelect();
      onDragStart(details.globalPosition);
    },
    onPanUpdate: (details) => onDragUpdate(details.globalPosition),
    onPanEnd: (details) => onDragEnd(details.globalPosition),
    child: MouseRegion(
      cursor: SystemMouseCursors.move,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? UiColor.bgAccentStrong : UiColor.white,
                borderRadius: UiRadius.allS,
                border: Border.all(color: isSelected ? UiColor.primary : UiColor.borderAccent),
                boxShadow: isSelected ? UiShadow.md : const [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: closeSize),
                    child: Text(
                      window.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: UiTypography.tileName,
                    ),
                  ),
                  Text(
                    context.translations.project_editor_tile_size(
                      window.width.round().toString(),
                      window.height.round().toString(),
                    ),
                    style: UiTypography.tileSize,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _CloseButton(isSelected: isSelected, onTap: onRemove),
          ),
          for (final handle in ResizeHandle.values)
            _HandleSlot(
              handle: handle,
              onStart: (position) => onResizeStart(handle, position),
              onUpdate: onResizeUpdate,
              onEnd: onResizeEnd,
            ),
        ],
      ),
    ),
  );
}

/// Positions one grip on the edge of the tile and turns drags into callbacks.
class _HandleSlot extends StatelessWidget {
  const _HandleSlot({required this.handle, required this.onStart, required this.onUpdate, required this.onEnd});

  final ResizeHandle handle;
  final ValueChanged<Offset> onStart;
  final ValueChanged<Offset> onUpdate;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    const corner = WindowTile.cornerHandleSize;
    const edge = WindowTile.edgeHandleThickness;

    final child = MouseRegion(
      cursor: _cursor,
      child: GestureDetector(
        onPanStart: (details) => onStart(details.globalPosition),
        onPanUpdate: (details) => onUpdate(details.globalPosition),
        onPanEnd: (_) => onEnd(),
        onPanCancel: onEnd,
        // Opaque so the strip catches the drag before the tile's own move gesture.
        behavior: HitTestBehavior.opaque,
        child: handle.isCorner ? _CornerGrip(handle: handle) : const SizedBox.expand(),
      ),
    );

    return switch (handle) {
      ResizeHandle.topLeft => Positioned(top: 0, left: 0, width: corner, height: corner, child: child),
      ResizeHandle.topRight => Positioned(top: 0, right: 0, width: corner, height: corner, child: child),
      ResizeHandle.bottomRight => Positioned(bottom: 0, right: 0, width: corner, height: corner, child: child),
      ResizeHandle.bottomLeft => Positioned(bottom: 0, left: 0, width: corner, height: corner, child: child),
      // The side strips stop short of the corners so the corner grips stay reachable.
      ResizeHandle.top => Positioned(top: 0, left: corner, right: corner, height: edge, child: child),
      ResizeHandle.bottom => Positioned(bottom: 0, left: corner, right: corner, height: edge, child: child),
      ResizeHandle.left => Positioned(left: 0, top: corner, bottom: corner, width: edge, child: child),
      ResizeHandle.right => Positioned(right: 0, top: corner, bottom: corner, width: edge, child: child),
    };
  }

  MouseCursor get _cursor => switch (handle) {
    ResizeHandle.topLeft || ResizeHandle.bottomRight => SystemMouseCursors.resizeUpLeftDownRight,
    ResizeHandle.topRight || ResizeHandle.bottomLeft => SystemMouseCursors.resizeUpRightDownLeft,
    ResizeHandle.top || ResizeHandle.bottom => SystemMouseCursors.resizeUpDown,
    ResizeHandle.left || ResizeHandle.right => SystemMouseCursors.resizeLeftRight,
  };
}

/// The visible corner grip from the design: two 2px edges.
///
/// The design showed a single grip at the bottom right; with four corners each one
/// draws the two edges that actually belong to it, so a grip always points outwards.
class _CornerGrip extends StatelessWidget {
  const _CornerGrip({required this.handle});

  final ResizeHandle handle;

  static const BorderSide _side = BorderSide(color: UiColor.primary, width: 2);

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(
        left: handle.movesLeftEdge ? _side : BorderSide.none,
        right: handle.movesRightEdge ? _side : BorderSide.none,
        top: handle.movesTopEdge ? _side : BorderSide.none,
        bottom: handle.movesBottomEdge ? _side : BorderSide.none,
      ),
    ),
  );
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.isSelected, required this.onTap});

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: WindowTile.closeSize,
        child: Center(
          child: UiSvgIcon(
            path: UiIcon.xMark,
            size: 11,
            color: isSelected ? UiColor.primary : UiColor.fgSubtle,
            strokeWidth: 2,
          ),
        ),
      ),
    ),
  );
}
