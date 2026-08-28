import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';

/// The outlined secondary action — 2px border, no fill.
class UiGhostButton extends StatelessWidget {
  const UiGhostButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: UiSize.ml, vertical: UiSize.sm),
    this.onDark = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final EdgeInsets padding;

  /// The variant used on the running-session and blocked surfaces.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return UiHoverRegion(
      enabled: isEnabled,
      builder: (context, isHovered) => GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.ease,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: UiRadius.allM,
            border: Border.all(
              color: onDark
                  ? (isHovered ? UiColor.borderOnDarkButtonHover : UiColor.borderOnDarkButton)
                  : (isHovered ? UiColor.borderStrong : UiColor.border),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: UiSize.s)],
              // Flexible so a long label ellipsises inside a narrow column instead of
              // overflowing the row — "Choose from Finder…" sits in a 268px column.
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UiTypography.button.copyWith(
                    color: onDark
                        ? (isHovered ? UiColor.onDark : UiColor.onDarkSubtle)
                        : (isEnabled ? UiColor.fgMuted : UiColor.fgDisabled),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
