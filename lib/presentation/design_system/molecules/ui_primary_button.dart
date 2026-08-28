import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_shadow.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';

/// The filled call to action: white mono label on brand blue, lifting on hover.
class UiPrimaryButton extends StatelessWidget {
  const UiPrimaryButton({
    required this.label,
    required this.onPressed,
    this.background = UiColor.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: UiSize.l, vertical: 9),
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Overridden by the launch button, which turns slate once the workspace is open.
  final Color background;

  final EdgeInsets padding;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    enabled: _isEnabled,
    builder: (context, isHovered) => GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: UiMotion.fast,
        curve: UiMotion.ease,
        transform: Matrix4.translationValues(0, isHovered ? UiMotion.liftButton : 0, 0),
        padding: padding,
        decoration: BoxDecoration(
          color: _isEnabled ? background : UiColor.border,
          borderRadius: UiRadius.allM,
          boxShadow: isHovered ? UiShadow.md : const [],
        ),
        child: Text(
          label.toUpperCase(),
          style: UiTypography.button.copyWith(color: _isEnabled ? UiColor.onDark : UiColor.fgSubtle),
        ),
      ),
    ),
  );
}
