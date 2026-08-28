import 'dart:typed_data';

import 'package:flutter/widgets.dart';
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
    required this.sizeLabel,
    required this.isSelected,
    this.icon,
    this.onDark = false,
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

  /// The readout under the name. The sheet shows percentages, the full-size overlay
  /// shows real points — which is the whole reason for arranging at full size.
  final String sizeLabel;

  /// PNG bytes of the represented app's icon, drawn in the middle of the tile.
  ///
  /// At full size a rectangle says nothing about which window it will become; the
  /// app's own icon does. Null for websites and while the icons are still loading.
  final Uint8List? icon;

  /// The full-size overlay lies on a darkened desktop: the tile turns translucent so
  /// what it will cover stays visible, and its text switches to the light palette.
  final bool onDark;

  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  final ValueChanged<Offset> onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<Offset> onDragEnd;

  final void Function(ResizeHandle handle, Offset globalPosition) onResizeStart;
  final ValueChanged<Offset> onResizeUpdate;
  final VoidCallback onResizeEnd;

  /// Edge length of a corner grip.
  ///
  /// Larger than the design's 14px: a tile here is drawn at the real window's size, so
  /// the grips have to be findable on a rectangle over a thousand points wide.
  static const double cornerHandleSize = 22;

  /// Thickness of the invisible hit strips along the four sides.
  static const double edgeHandleThickness = 10;

  /// Edge length of the round close button, and of the glyph inside it.
  static const double closeSize = 34;
  static const double closeGlyphSize = 15;

  /// Share of the shorter tile edge the icon takes, and the range it stays inside.
  static const double iconFraction = 0.28;
  static const double iconMin = 24;
  static const double iconMax = 128;

  Color get _fill => switch ((onDark, isSelected)) {
    // Roughly a quarter opaque: enough to read as a surface, sheer enough to see
    // through to whatever the window will end up covering.
    (true, false) => UiColor.white.withValues(alpha: 0.22),
    (true, true) => UiColor.accent.withValues(alpha: 0.38),
    (false, false) => UiColor.white,
    (false, true) => UiColor.bgAccentStrong,
  };

  Color get _border => switch ((onDark, isSelected)) {
    (true, false) => UiColor.onDarkAccent,
    (true, true) => UiColor.accent,
    (false, false) => UiColor.borderAccent,
    (false, true) => UiColor.primary,
  };

  Color get _nameColor => onDark ? UiColor.onDark : UiColor.fgStrong;

  Color get _metaColor => onDark ? UiColor.onDarkMuted : UiColor.fgSubtle;

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
                color: _fill,
                borderRadius: UiRadius.allS,
                border: Border.all(color: _border),
                boxShadow: isSelected && !onDark ? UiShadow.md : const [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    // Keeps the name clear of the close button and the corner grip.
                    padding: const EdgeInsets.only(right: closeSize + cornerHandleSize),
                    child: Text(
                      window.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: UiTypography.tileName.copyWith(color: _nameColor),
                    ),
                  ),
                  Text(sizeLabel, style: UiTypography.tileSize.copyWith(color: _metaColor)),
                ],
              ),
            ),
          ),
          if (icon != null)
            Positioned.fill(
              child: IgnorePointer(child: _CentredIcon(icon: icon!)),
            ),
          for (final handle in ResizeHandle.values)
            _HandleSlot(
              handle: handle,
              onStart: (position) => onResizeStart(handle, position),
              onUpdate: onResizeUpdate,
              onEnd: onResizeEnd,
            ),
          // After the grips, and clear of the top-right corner: otherwise the corner
          // grip lies on top of the button and swallows every click meant for it.
          Positioned(
            top: 0,
            right: cornerHandleSize,
            child: _CloseButton(color: isSelected ? UiColor.primary : _metaColor, onDark: onDark, onTap: onRemove),
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

/// The app's own icon, sized to the tile and centred.
class _CentredIcon extends StatelessWidget {
  const _CentredIcon({required this.icon});

  final Uint8List icon;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final edge = (constraints.biggest.shortestSide * WindowTile.iconFraction).clamp(
        WindowTile.iconMin,
        WindowTile.iconMax,
      );

      // A tile can be smaller than the icon's minimum; then it simply has no room.
      if (constraints.biggest.shortestSide < WindowTile.iconMin * 1.5) return const SizedBox.shrink();

      return Center(
        child: Image.memory(icon, width: edge, height: edge, filterQuality: FilterQuality.medium),
      );
    },
  );
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
  const _CloseButton({required this.color, required this.onDark, required this.onTap});

  final Color color;
  final bool onDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      // Opaque so the whole circle answers, not just the strokes of the glyph.
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: WindowTile.closeSize,
        height: WindowTile.closeSize,
        decoration: BoxDecoration(
          // A disc on the dark overlay, where a bare glyph would vanish against
          // whatever the desktop shows through the translucent tile.
          color: onDark ? UiColor.bgDark.withValues(alpha: 0.55) : null,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: UiSvgIcon(path: UiIcon.xMark, size: WindowTile.closeGlyphSize, color: color, strokeWidth: 2),
        ),
      ),
    ),
  );
}
