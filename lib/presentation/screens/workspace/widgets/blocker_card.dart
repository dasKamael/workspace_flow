import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_error_reason.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/domain/focus/model/focus_stats.dart';
import 'package:workspace_flow/domain/focus/service/focus_stats.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_chip.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_switch.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_tick_box.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_card.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_lock_overlay.dart';

/// The right column: profiles, their entries, and the arming switch.
///
/// While armed the card goes dark and profile switching gives way to the armed
/// profile's plain name. Adding and editing entries only happens in the profile
/// editor; the overview is just profiles, items, and the switch.
class BlockerCard extends ConsumerStatefulWidget {
  const BlockerCard({super.key});

  @override
  ConsumerState<BlockerCard> createState() => _BlockerCardState();
}

class _BlockerCardState extends ConsumerState<BlockerCard> {
  /// Bumped on every arming so the lock animation replays.
  int _armCount = 0;

  Future<void> _toggleArmed({required bool armed, required BlockerProfile? profile}) async {
    await ref.read(blockerServiceProvider.notifier).setArmed(armed: armed);
    // Only plays the lock-in animation once arming actually succeeded — a permission
    // error must not visually claim the profile is enforced when it isn't.
    if (armed && ref.read(blockerServiceProvider)) setState(() => _armCount++);
  }

  String _errorMessage(BuildContext context, BlockerErrorReason reason) => switch (reason) {
    BlockerErrorReason.armFailed => context.translations.blocker_error_arm_failed,
    BlockerErrorReason.disarmFailed => context.translations.blocker_error_disarm_failed,
    BlockerErrorReason.sitePermissionDenied => context.translations.blocker_error_site_permission_denied,
  };

  @override
  Widget build(BuildContext context) {
    final isArmed = ref.watch(blockerServiceProvider);
    final profiles = ref.watch(blockerProfilesProvider).value ?? const <BlockerProfile>[];
    final profile = ref.watch(selectedProfileProvider);
    final stats = ref.watch(focusStatsProvider).value ?? const FocusStats();

    ref.listen<BlockerErrorReason?>(blockerErrorServiceProvider, (previous, next) {
      if (next == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage(context, next))));
      ref.read(blockerErrorServiceProvider.notifier).clear();
    });

    return UiCard(
      clipBehavior: Clip.antiAlias,
      background: isArmed ? UiColor.bgDark : UiColor.white,
      borderColor: isArmed ? UiColor.bgDark : UiColor.border,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.translations.blocker_label.toUpperCase(),
                    style: UiTypography.cardLabel.copyWith(color: isArmed ? UiColor.onDarkAccent : UiColor.fgSubtle),
                  ),
                  UiSwitch(
                    value: isArmed,
                    onChanged: (value) => _toggleArmed(armed: value, profile: profile),
                  ),
                ],
              ),
              UiSpacer.ml,
              _ProfileBlock(profile: profile, profiles: profiles, isArmed: isArmed),
              UiSpacer.s,
              _SweepBar(key: ValueKey(_armCount), isArmed: isArmed),
              UiSpacer.s,
              Expanded(
                child: _ItemList(key: ValueKey('$_armCount|${profile?.id}'), profile: profile, isArmed: isArmed),
              ),
              UiSpacer.ml,
              _BlockedTodayTile(count: stats.blockedToday, isArmed: isArmed),
            ],
          ),
          if (isArmed) Positioned.fill(child: BlockerLockOverlay(key: ValueKey(_armCount))),
        ],
      ),
    );
  }
}

class _ProfileBlock extends ConsumerWidget {
  const _ProfileBlock({required this.profile, required this.profiles, required this.isArmed});

  final BlockerProfile? profile;
  final List<BlockerProfile> profiles;
  final bool isArmed;

  /// Fixed height so swapping chips for the armed profile name does not move anything.
  static const double rowHeight = 30;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        context.translations.blocker_profile_label.toUpperCase(),
        style: UiTypography.cardLabel.copyWith(color: isArmed ? UiColor.onDarkAccent : UiColor.fgSubtle),
      ),
      UiSpacer.s,
      SizedBox(
        height: rowHeight,
        child: isArmed
            ? Align(
                alignment: Alignment.centerLeft,
                child: Text(profile?.name ?? '', style: UiTypography.itemTitle.copyWith(color: UiColor.onDark)),
              )
            // Editing and adding sit right on the chips they act on — a pencil next to
            // whichever profile is selected, a "+" chip of its own at the end — rather
            // than text links up in the header, disconnected from what they touch.
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: profiles.length + 1,
                separatorBuilder: (_, _) => UiSpacer.xs,
                itemBuilder: (context, index) {
                  if (index == profiles.length) {
                    return Center(
                      child: UiChip(
                        label: '+',
                        onTap: () => context.goNamed(
                          UiRoute.profileEditor.name,
                          pathParameters: {RoutePathParam.id.name: kNewEntitySegment},
                        ),
                      ),
                    );
                  }

                  final isSelected = profiles[index].id == profile?.id;
                  return Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UiChip(
                          label: profiles[index].name,
                          isSelected: isSelected,
                          onTap: () => ref.read(selectedProfileServiceProvider.notifier).select(profiles[index].id),
                        ),
                        if (isSelected) ...[UiSpacer.xs, _EditProfileButton(profileId: profiles[index].id)],
                      ],
                    ),
                  );
                },
              ),
      ),
    ],
  );
}

/// The pencil next to the selected profile chip — edits that profile specifically,
/// which a link sitting elsewhere in the card could only imply.
class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton({required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    builder: (context, isHovered) => GestureDetector(
      onTap: () => context.goNamed(UiRoute.profileEditor.name, pathParameters: {RoutePathParam.id.name: '$profileId'}),
      child: Container(
        padding: const EdgeInsets.all(UiSize.xs),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isHovered ? UiColor.borderAccentStrong : UiColor.border),
        ),
        child: UiSvgIcon(path: UiIcon.pencil, size: 12, color: UiColor.fgSubtle, strokeWidth: 1.5),
      ),
    ),
  );
}

/// The 2px activation sweep that scales in from the left.
class _SweepBar extends StatefulWidget {
  const _SweepBar({required this.isArmed, super.key});

  final bool isArmed;

  @override
  State<_SweepBar> createState() => _SweepBarState();
}

class _SweepBarState extends State<_SweepBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.sweep);

  @override
  void initState() {
    super.initState();
    if (widget.isArmed) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 2,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: Curves.easeOut.transform(_controller.value),
        child: Opacity(
          opacity: 1 - _controller.value,
          child: const ColoredBox(color: UiColor.accent),
        ),
      ),
    ),
  );
}

class _ItemList extends ConsumerWidget {
  const _ItemList({required this.profile, required this.isArmed, super.key});

  final BlockerProfile? profile;
  final bool isArmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = profile?.items ?? const <BlockedItem>[];

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      separatorBuilder: (_, _) => UiSpacer.xs,
      itemBuilder: (context, index) => _LockInFlash(
        // Staggered flash when the blocker is armed; falls back to the row's own styles.
        delay: isArmed ? UiMotion.lockInStagger * index : Duration.zero,
        enabled: isArmed,
        child: _ItemRow(
          item: items[index],
          isArmed: isArmed,
          onTap: () async {
            await ref.read(blockerProfileServiceProvider.notifier).toggleItem(items[index]);
            await ref.read(blockerServiceProvider.notifier).reapply();
          },
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.isArmed, required this.onTap});

  final BlockedItem item;
  final bool isArmed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    builder: (context, isHovered) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: UiMotion.fast,
        curve: UiMotion.ease,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: isHovered ? (isArmed ? UiColor.borderOnDarkSubtle : UiColor.bgSubtle) : null,
          borderRadius: UiRadius.allMl,
          border: Border.all(color: isArmed ? UiColor.borderOnDark : UiColor.border),
        ),
        child: Row(
          children: [
            UiTickBox(checked: item.enabled, onDark: isArmed),
            const SizedBox(width: UiSize.sm),
            Expanded(
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: UiTypography.blockerItem.copyWith(
                  color: item.enabled
                      ? (isArmed ? UiColor.onDarkStrong : UiColor.fgBody)
                      : (isArmed ? UiColor.onDarkMuted : UiColor.fgDisabled),
                  decoration: item.enabled ? null : TextDecoration.lineThrough,
                  decorationColor: isArmed ? UiColor.onDarkMuted : UiColor.fgDisabled,
                ),
              ),
            ),
            Text(
              item.kind == BlockedItemKind.site
                  ? context.translations.common_kind_site
                  : context.translations.common_kind_app,
              style: UiTypography.blockerKind.copyWith(color: isArmed ? UiColor.onDarkMuted : UiColor.fgSubtle),
            ),
          ],
        ),
      ),
    ),
  );
}

/// `lockIn` — a brief tint and nudge, then back to the row's own styles.
class _LockInFlash extends StatefulWidget {
  const _LockInFlash({required this.child, required this.delay, required this.enabled});

  final Widget child;
  final Duration delay;
  final bool enabled;

  @override
  State<_LockInFlash> createState() => _LockInFlashState();
}

class _LockInFlashState extends State<_LockInFlash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.lockIn);

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
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
    animation: _controller,
    builder: (context, child) {
      // Peaks in the middle and returns to zero, so no fill mode is needed.
      final intensity = _controller.value == 0 ? 0.0 : (1 - (_controller.value - 0.3).abs() / 0.7).clamp(0.0, 1.0);
      return Transform.translate(
        offset: Offset(-3 * intensity, 0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: UiColor.bgAccent.withValues(alpha: 0.35 * intensity),
            borderRadius: UiRadius.allMl,
          ),
          child: child,
        ),
      );
    },
    child: widget.child,
  );
}

class _BlockedTodayTile extends StatelessWidget {
  const _BlockedTodayTile({required this.count, required this.isArmed});

  final int count;
  final bool isArmed;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(UiSize.l),
    decoration: BoxDecoration(
      borderRadius: UiRadius.allXl,
      border: Border.all(color: isArmed ? UiColor.borderOnDark : UiColor.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.translations.blocker_blocked_today_label.toUpperCase(),
          style: UiTypography.cardLabel.copyWith(color: isArmed ? UiColor.onDarkAccent : UiColor.fgSubtle),
        ),
        UiSpacer.xs,
        Text('$count', style: UiTypography.statValue.copyWith(color: isArmed ? UiColor.onDark : UiColor.fgStrong)),
        UiSpacer.xxs,
        Text(
          context.translations.blocker_blocked_today_caption,
          style: UiTypography.caption.copyWith(color: isArmed ? UiColor.onDarkMuted : UiColor.fgMuted),
        ),
      ],
    ),
  );
}
