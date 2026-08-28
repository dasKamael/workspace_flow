import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/svg_path.util.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';

/// Renders one of the [UiIcon] paths at [size] logical pixels.
///
/// Set [filled] for the solid icons (the check), leave it false for the outline set.
class UiSvgIcon extends StatelessWidget {
  const UiSvgIcon({
    required this.path,
    required this.size,
    required this.color,
    this.filled = false,
    this.strokeWidth = UiIcon.outlineStrokeWidth,
    super.key,
  });

  /// Path data from [UiIcon].
  final String path;

  final double size;
  final Color color;

  /// Fill instead of stroke — for the solid icon set.
  final bool filled;

  /// Stroke width in view-box units; scaled together with the path.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final viewBox = filled ? UiIcon.solidViewBox : UiIcon.outlineViewBox;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _SvgIconPainter(
          path: SvgPathUtil.scaled(path, viewBox: viewBox, size: size),
          color: color,
          filled: filled,
          strokeWidth: strokeWidth * (size / viewBox),
        ),
      ),
    );
  }
}

class _SvgIconPainter extends CustomPainter {
  _SvgIconPainter({required this.path, required this.color, required this.filled, required this.strokeWidth});

  final Path path;
  final Color color;
  final bool filled;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SvgIconPainter old) =>
      old.path != path || old.color != color || old.filled != filled || old.strokeWidth != strokeWidth;
}
