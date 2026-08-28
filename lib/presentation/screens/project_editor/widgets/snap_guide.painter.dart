import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';

/// Draws the alignment guides of a running drag.
///
/// [guidesX] and [guidesY] are percent positions on the monitor — a vertical line for
/// each x, a horizontal line for each y. Dashed and one pixel wide, so they read as
/// guides rather than as part of the layout, and they only exist while a tile is
/// actually sitting on a magnet.
class SnapGuidePainter extends CustomPainter {
  const SnapGuidePainter({required this.guidesX, required this.guidesY});

  final List<double> guidesX;
  final List<double> guidesY;

  static const double _dash = 4;
  static const double _gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = UiColor.accent
      ..strokeWidth = 1
      ..isAntiAlias = false;

    for (final percent in guidesX) {
      final x = size.width * percent / 100;
      _dashedLine(canvas, paint, from: Offset(x, 0), to: Offset(x, size.height));
    }
    for (final percent in guidesY) {
      final y = size.height * percent / 100;
      _dashedLine(canvas, paint, from: Offset(0, y), to: Offset(size.width, y));
    }
  }

  void _dashedLine(Canvas canvas, Paint paint, {required Offset from, required Offset to}) {
    final total = (to - from).distance;
    if (total <= 0) return;

    final step = (to - from) / total;
    var travelled = 0.0;

    while (travelled < total) {
      final end = (travelled + _dash).clamp(0.0, total);
      canvas.drawLine(from + step * travelled, from + step * end, paint);
      travelled = end + _gap;
    }
  }

  @override
  bool shouldRepaint(SnapGuidePainter old) => !listEquals(old.guidesX, guidesX) || !listEquals(old.guidesY, guidesY);
}
