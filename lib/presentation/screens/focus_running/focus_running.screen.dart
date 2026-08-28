import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/common/extension/duration.extension.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';
import 'package:workspace_flow/domain/focus/service/focus_session.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';

/// The distraction-free session view. It replaces the whole window body — nothing else
/// is visible while a session runs.
class FocusRunningScreen extends ConsumerWidget {
  const FocusRunningScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(focusSessionServiceProvider);

    // Expanded rather than shrink-wrapped: the session replaces the whole window body,
    // and a Stack would otherwise size itself to the countdown column.
    return SizedBox.expand(
      child: ColoredBox(
        color: UiColor.bgDark,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const _StartBurst(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _PulsingDot(),
                    UiSpacer.s,
                    Text(context.translations.focus_running_badge.toUpperCase(), style: UiTypography.sessionBadge),
                  ],
                ),
                UiSpacer.xxl,
                _SessionRing(session: session),
                UiSpacer.xxl,
                UiGhostButton(
                  label: context.translations.focus_session_stop,
                  onDark: true,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  onPressed: ref.read(focusSessionServiceProvider.notifier).stop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionRing extends StatelessWidget {
  const _SessionRing({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: UiSize.focusRing,
    child: TweenAnimationBuilder<double>(
      // One second, linear — the ring glides instead of stepping once per tick.
      duration: UiMotion.tick,
      curve: Curves.linear,
      tween: Tween(end: session.remainingFraction),
      builder: (context, fraction, child) => CustomPaint(
        painter: _SessionRingPainter(fraction: fraction),
        child: child,
      ),
      child: Center(
        // No animation on the digits — the design is explicit about that.
        child: Text(Duration(seconds: session.displaySeconds).toCountdown, style: UiTypography.sessionValue),
      ),
    ),
  );
}

class _SessionRingPainter extends CustomPainter {
  _SessionRingPainter({required this.fraction});

  final double fraction;

  /// Authored in a 200×200 view box, like the dial.
  static const double viewBox = 200;
  static const double radius = 91;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / viewBox;
    final centre = Offset(size.width / 2, size.height / 2);
    final r = radius * scale;

    canvas.drawCircle(
      centre,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * scale
        ..color = UiColor.trackOnDark,
    );

    if (fraction <= 0) return;

    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: r),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * scale
        ..strokeCap = StrokeCap.round
        ..color = UiColor.accent,
    );
  }

  @override
  bool shouldRepaint(_SessionRingPainter old) => old.fraction != fraction;
}

/// `startBurst` — a blue circle expands and fades once, when the view appears.
class _StartBurst extends StatefulWidget {
  const _StartBurst();

  @override
  State<_StartBurst> createState() => _StartBurstState();
}

class _StartBurstState extends State<_StartBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.startBurst)
    ..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Opacity(
        opacity: 1 - _controller.value,
        child: Transform.scale(
          scale: 0.05 + 2.55 * Curves.easeOut.transform(_controller.value),
          child: Container(
            width: 300,
            height: 300,
            decoration: const BoxDecoration(color: UiColor.primary, shape: BoxShape.circle),
          ),
        ),
      ),
    ),
  );
}

/// `pulseDot` — the 8px "in focus" dot, breathing every 2.6s.
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.pulseDot)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => Opacity(
      opacity: 0.4 + 0.6 * (0.5 + 0.5 * math.cos(_controller.value * 2 * math.pi)),
      child: Container(
        width: UiSize.statusDot,
        height: UiSize.statusDot,
        decoration: const BoxDecoration(color: UiColor.onDarkAccent, shape: BoxShape.circle),
      ),
    ),
  );
}
