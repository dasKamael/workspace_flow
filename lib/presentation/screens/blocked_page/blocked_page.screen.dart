import 'package:flutter/widgets.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// The intercept screen shown when a blocked app or site is opened.
///
/// It runs in its own borderless 700×340 window, driven by a second Flutter engine, so
/// it can appear while the main window is hidden during a session.
class BlockedPageScreen extends StatelessWidget {
  const BlockedPageScreen({
    required this.target,
    required this.profileName,
    this.projectName,
    this.endsAt,
    this.remaining,
    this.unlockMinutes = 2,
    this.unlocksLeft = 1,
    this.onBackToWork,
    this.onUnlock,
    super.key,
  });

  /// The app or domain that was intercepted.
  final String target;
  final String profileName;
  final String? projectName;

  /// Wall-clock end of the running session, if one is running.
  final String? endsAt;

  /// Remaining time of the running session, e.g. "12:34".
  final String? remaining;

  final int unlockMinutes;
  final int unlocksLeft;

  final VoidCallback? onBackToWork;
  final VoidCallback? onUnlock;

  @override
  Widget build(BuildContext context) => Container(
    width: UiSize.blockedPageWidth,
    height: UiSize.blockedPageHeight,
    decoration: const BoxDecoration(color: UiColor.bgDark, borderRadius: UiRadius.allXxl),
    padding: const EdgeInsets.all(UiSize.xxxl),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: UiColor.accentChipOnDark, borderRadius: UiRadius.allXl),
          child: const Center(
            child: UiSvgIcon(path: UiIcon.noSymbol, size: UiSize.m * 2, color: UiColor.onDarkAccent, strokeWidth: 2),
          ),
        ),
        UiSpacer.l,
        Text(
          context.translations.blocked_page_eyebrow(profileName, target).toUpperCase(),
          style: UiTypography.sessionBadge,
          textAlign: TextAlign.center,
        ),
        UiSpacer.m,
        Text(
          endsAt == null
              ? context.translations.blocked_page_headline_open_end
              : context.translations.blocked_page_headline(endsAt!),
          style: UiTypography.headlineOnDark,
          textAlign: TextAlign.center,
        ),
        UiSpacer.s,
        Text(
          context.translations.blocked_page_meta(profileName, projectName ?? '—', remaining ?? '—'),
          style: UiTypography.dialMeta.copyWith(color: UiColor.onDarkMuted),
          textAlign: TextAlign.center,
        ),
        UiSpacer.xl,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiPrimaryButton(
              label: context.translations.blocked_page_back_to_work,
              padding: const EdgeInsets.symmetric(horizontal: UiSize.xl, vertical: UiSize.m),
              onPressed: onBackToWork,
            ),
            UiSpacer.sm,
            UiGhostButton(
              label: context.translations.blocked_page_unlock(unlocksLeft, unlockMinutes),
              onDark: true,
              padding: const EdgeInsets.symmetric(horizontal: UiSize.xl, vertical: 13),
              onPressed: unlocksLeft > 0 ? onUnlock : null,
            ),
          ],
        ),
      ],
    ),
  );
}
