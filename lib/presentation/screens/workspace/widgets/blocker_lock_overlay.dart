import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// The arming animation: a padlock pops, its shackle drops in, and a ring expands past
/// the edge of the card.
///
/// Non-interactive and self-removing. Give it a `ValueKey` that changes on every
/// arming so the whole sequence replays.
class BlockerLockOverlay extends StatefulWidget {
  const BlockerLockOverlay({super.key});

  static const double lockSize = 72;
  static const double ringSize = 150;

  @override
  State<BlockerLockOverlay> createState() => _BlockerLockOverlayState();
}

class _BlockerLockOverlayState extends State<BlockerLockOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.lockPop)..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        // One-shot: once it has played, it leaves the tree instead of sitting on the
        // card as a fully transparent layer.
        if (_controller.isCompleted) return const SizedBox.shrink();
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(opacity: _ringOpacity(t), child: _ring(_ringScale(t))),
            Opacity(
              opacity: _lockOpacity(t),
              child: Transform.scale(scale: _lockScale(t), child: _lock(t)),
            ),
          ],
        );
      },
    ),
  );

  Widget _ring(double scale) => Transform.scale(
    scale: scale,
    child: Container(
      width: BlockerLockOverlay.ringSize,
      height: BlockerLockOverlay.ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: UiColor.accent, width: 2),
      ),
    ),
  );

  /// The body sits still while the shackle drops the last five pixels into place.
  Widget _lock(double t) {
    final shackleDrop = -5 * (1 - Curves.easeOut.transform((t * 2).clamp(0.0, 1.0)));

    return SizedBox.square(
      dimension: BlockerLockOverlay.lockSize,
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(0, shackleDrop),
            child: const UiSvgIcon(
              path: UiIcon.lockShackle,
              size: BlockerLockOverlay.lockSize,
              color: UiColor.onDarkAccent,
              strokeWidth: 2,
            ),
          ),
          const UiSvgIcon(
            path: UiIcon.lockBody,
            size: BlockerLockOverlay.lockSize,
            color: UiColor.onDarkAccent,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }

  /// `lockPop` — scale 0.7 → 1 → 1.04, opacity 0 → 1 → 0.
  double _lockScale(double t) => t < 0.4 ? 0.7 + 0.3 * (t / 0.4) : 1 + 0.04 * ((t - 0.4) / 0.6);

  /// Clamped because the piecewise ramp lands a hair outside [0, 1] at t = 1 through
  /// floating-point rounding, and [Opacity] asserts on that.
  double _lockOpacity(double t) {
    if (t < 0.25) return (t / 0.25).clamp(0.0, 1.0);
    if (t < 0.7) return 1;
    return (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0);
  }

  /// `ringOut` — scale 0.5 → 2.1, opacity 0.45 → 0.
  double _ringScale(double t) => 0.5 + 1.6 * Curves.easeOut.transform(t);

  double _ringOpacity(double t) => (0.45 * (1 - t)).clamp(0.0, 1.0);
}
