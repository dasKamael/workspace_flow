import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// A pill: the app-library chips in the editor and the profile chips in the blocker.
///
/// [isUsed] greys the chip out — an app already placed in the current layout cannot be
/// dragged in a second time.
class UiChip extends StatelessWidget {
  const UiChip({
    required this.label,
    this.onTap,
    this.onRemove,
    this.icon,
    this.isSelected = false,
    this.isUsed = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;

  /// The app's own icon, drawn before the label — makes several project variants of
  /// the same app (same name prefix) easy to tell apart from unrelated ones at a glance.
  final Uint8List? icon;

  /// Shows a small × inside the pill when set — the app library's own chips are
  /// removable this way, while the blocker's profile-selection chips leave this null
  /// and stay exactly as they were.
  final VoidCallback? onRemove;

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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Image.memory(icon!, width: UiSize.l, height: UiSize.l, filterQuality: FilterQuality.medium),
                const SizedBox(width: UiSize.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UiTypography.chip.copyWith(color: foreground),
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: UiSize.xs),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: UiSvgIcon(path: UiIcon.xMark, size: 10, color: foreground, strokeWidth: 2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
