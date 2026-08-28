import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';

/// Maps a pointer position on the dial to a session length.
///
/// The angle is measured from twelve o'clock, clockwise, as `atan2(dx, -dy)`; a full
/// turn is [maxMinutes]. Snapping and clamping happen in `FocusSessionService`, which
/// owns the value — this only converts geometry.
double minutesFromOffset(Offset local, Size size, {required int maxMinutes}) {
  final centre = Offset(size.width / 2, size.height / 2);
  final delta = local - centre;
  var angle = math.atan2(delta.dx, -delta.dy);
  if (angle < 0) angle += 2 * math.pi;
  return angle / (2 * math.pi) * maxMinutes;
}

/// The egg-timer dial: a track, a progress arc, tick marks and a draggable knob.
class FocusDial extends StatefulWidget {
  const FocusDial({
    required this.minutes,
    required this.maxMinutes,
    required this.size,
    required this.onChanged,
    required this.onDragStateChanged,
    required this.centre,
    super.key,
  });

  final int minutes;
  final int maxMinutes;
  final double size;

  /// Raw, unsnapped minutes under the pointer.
  final ValueChanged<double> onChanged;

  final ValueChanged<bool> onDragStateChanged;

  /// The value and the "ends 10:28" line drawn in the middle.
  final Widget centre;

  @override
  State<FocusDial> createState() => _FocusDialState();
}

class _FocusDialState extends State<FocusDial> {
  bool _isDragging = false;

  void _setDragging(bool value) {
    setState(() => _isDragging = value);
    widget.onDragStateChanged(value);
  }

  void _report(Offset local) =>
      widget.onChanged(minutesFromOffset(local, Size(widget.size, widget.size), maxMinutes: widget.maxMinutes));

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
    child: GestureDetector(
      onPanStart: (details) {
        _setDragging(true);
        _report(details.localPosition);
      },
      onPanUpdate: (details) => _report(details.localPosition),
      onPanEnd: (_) => _setDragging(false),
      onPanCancel: () => _setDragging(false),
      child: SizedBox.square(
        dimension: widget.size,
        child: TweenAnimationBuilder<double>(
          duration: UiMotion.dialArc,
          curve: UiMotion.ease,
          tween: Tween(end: widget.minutes / widget.maxMinutes),
          builder: (context, fraction, child) => CustomPaint(
            painter: _FocusDialPainter(fraction: fraction, minutes: widget.minutes, isDragging: _isDragging),
            child: child,
          ),
          child: Center(child: widget.centre),
        ),
      ),
    ),
  );
}

class _FocusDialPainter extends CustomPainter {
  _FocusDialPainter({required this.fraction, required this.minutes, required this.isDragging});

  /// Filled portion of the dial, 0–1.
  final double fraction;
  final int minutes;
  final bool isDragging;

  /// The design is authored in a 200×200 view box; every radius below is in those units.
  static const double viewBox = 200;
  static const double trackRadius = 91;
  static const double tickOuterRadius = 80;
  static const double tickInnerRadiusInactive = 72;
  static const double tickInnerRadiusActive = 68;

  /// One tick every five minutes over a 120 minute dial.
  static const int tickCount = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / viewBox;
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = trackRadius * scale;

    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * scale
        ..color = UiColor.bgMuted,
    );

    _paintTicks(canvas, centre, scale);

    if (fraction > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: centre, radius: radius),
        -math.pi / 2,
        2 * math.pi * fraction,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * scale
          ..strokeCap = StrokeCap.round
          ..color = UiColor.primary,
      );
      _paintKnob(canvas, centre, radius, scale);
    }
  }

  void _paintTicks(Canvas canvas, Offset centre, double scale) {
    final activeTicks = (fraction * tickCount).round();

    for (var index = 0; index < tickCount; index++) {
      final isActive = index < activeTicks;
      final angle = -math.pi / 2 + index / tickCount * 2 * math.pi;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final inner = isActive ? tickInnerRadiusActive : tickInnerRadiusInactive;

      canvas.drawLine(
        centre + direction * (inner * scale),
        centre + direction * (tickOuterRadius * scale),
        Paint()
          ..strokeWidth = (isActive ? 2.6 : 2) * scale
          ..color = isActive ? UiColor.accent : UiColor.border,
      );
    }
  }

  void _paintKnob(Canvas canvas, Offset centre, double radius, double scale) {
    final angle = -math.pi / 2 + 2 * math.pi * fraction;
    final position = centre + Offset(math.cos(angle), math.sin(angle)) * radius;
    final knobScale = isDragging ? 1.22 : 1.0;

    canvas
      ..drawCircle(position, 8 * scale * knobScale, Paint()..color = UiColor.white)
      ..drawCircle(
        position,
        8 * scale * knobScale,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1 * scale
          ..color = UiColor.border,
      )
      ..drawCircle(position, 3.4 * scale * knobScale, Paint()..color = UiColor.primary);
  }

  @override
  bool shouldRepaint(_FocusDialPainter old) =>
      old.fraction != fraction || old.minutes != minutes || old.isDragging != isDragging;
}
