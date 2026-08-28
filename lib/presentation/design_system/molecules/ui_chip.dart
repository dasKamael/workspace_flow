import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';

/// A pill: the app-library chips in the editor and the profile chips in the blocker.
///
/// [isUsed] greys the chip out — an app already placed in the current layout cannot be
/// dragged in a second time.
class UiChip extends StatelessWidget {
  const UiChip({required this.label, this.onTap, this.isSelected = false, this.isUsed = false, super.key});

  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isUsed;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final Color border;

    if (isUsed) {
      background = UiColor.bgMuted;
      foreground = UiColor.fgDisabled;
      border = UiColor.bgMuted;
    } else if (isSelected) {
      background = UiColor.bgAccent;
      foreground = UiColor.fgAccentHover;
      border = UiColor.primary;
    } else {
      background = UiColor.white;
      foreground = UiColor.fg;
      border = UiColor.border;
    }

    return UiHoverRegion(
      enabled: !isUsed && onTap != null,
      builder: (context, isHovered) => GestureDetector(
        onTap: isUsed ? null : onTap,
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.ease,
          padding: const EdgeInsets.symmetric(horizontal: UiSize.sm, vertical: UiSize.xs),
          decoration: BoxDecoration(
            color: background,
            borderRadius: UiRadius.allFull,
            border: Border.all(color: isHovered ? UiColor.borderAccentStrong : border),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: UiTypography.chip.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
