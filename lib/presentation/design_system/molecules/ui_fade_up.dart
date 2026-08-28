import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';

/// `fadeUp` / `rowIn` — fades in while sliding up by [offset].
///
/// [delay] carries the stagger (60ms between project cards, 40ms between app rows).
/// Give the widget a `ValueKey` that changes when the animation should replay; the
/// prototype alternated two identical keyframe names for the same reason.
class UiFadeUp extends StatefulWidget {
  const UiFadeUp({
    required this.child,
    this.duration = UiMotion.cardIn,
    this.delay = Duration.zero,
    this.offset = 8,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  /// Distance travelled, in logical pixels.
  final double offset;

  @override
  State<UiFadeUp> createState() => _UiFadeUpState();
}

class _UiFadeUpState extends State<UiFadeUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: UiMotion.ease);

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => Opacity(
      opacity: _animation.value,
      child: Transform.translate(offset: Offset(0, widget.offset * (1 - _animation.value)), child: child),
    ),
    child: widget.child,
  );
}
