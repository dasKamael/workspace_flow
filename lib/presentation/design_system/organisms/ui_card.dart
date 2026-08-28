import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';

/// An Apple-style panel: white, one-pixel border, 14px radius, flat at rest.
///
/// [background] and [borderColor] are animated so the blocker card can cross-fade into
/// its dark armed state without swapping widgets.
class UiCard extends StatelessWidget {
  const UiCard({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
    this.background = UiColor.white,
    this.borderColor = UiColor.border,
    this.borderRadius = UiRadius.allXxl,
    this.duration = UiMotion.slow,
    this.clipBehavior = Clip.none,
    super.key,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color background;
  final Color borderColor;
  final BorderRadius borderRadius;
  final Duration duration;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: UiMotion.ease,
    clipBehavior: clipBehavior,
    padding: padding,
    decoration: BoxDecoration(
      color: background,
      borderRadius: borderRadius,
      border: Border.all(color: borderColor),
    ),
    child: child,
  );
}
