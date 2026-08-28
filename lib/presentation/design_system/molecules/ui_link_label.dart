import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';

/// A small uppercase mono link ("+ NEW", "EDIT", "DELETE").
class UiLinkLabel extends StatelessWidget {
  const UiLinkLabel({
    required this.label,
    required this.onTap,
    this.color = UiColor.fgAccent,
    this.hoverColor = UiColor.fgAccentHover,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final Color hoverColor;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    enabled: onTap != null,
    builder: (context, isHovered) => GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedDefaultTextStyle(
        duration: UiMotion.fast,
        curve: UiMotion.ease,
        style: UiTypography.linkLabel.copyWith(color: isHovered ? hoverColor : color),
        child: Text(label.toUpperCase()),
      ),
    ),
  );
}
