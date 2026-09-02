import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/common/extension/duration.extension.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';
import 'package:workspace_flow/domain/focus/model/focus_stats.dart';
import 'package:workspace_flow/domain/focus/service/focus_preset.service.dart';
import 'package:workspace_flow/domain/focus/service/focus_session.service.dart';
import 'package:workspace_flow/domain/focus/service/focus_stats.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/focus_dial.dart';

/// The bottom of the middle column: dial, presets and the start button.
class FocusSessionCard extends ConsumerStatefulWidget {
  const FocusSessionCard({super.key});

  @override
  ConsumerState<FocusSessionCard> createState() => _FocusSessionCardState();
}

class _FocusSessionCardState extends ConsumerState<FocusSessionCard> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(focusSessionServiceProvider);
    final service = ref.read(focusSessionServiceProvider.notifier);

    return UiCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translations.focus_session_label.toUpperCase(), style: UiTypography.cardLabel),
              Text(
                _isDragging
                    ? context.translations.focus_session_hint_dragging(session.minutes)
                    : context.translations.focus_session_hint_idle,
                style: UiTypography.itemSubtitle,
              ),
            ],
          ),
          UiSpacer.l,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FocusDial(
                minutes: session.minutes,
                maxMinutes: FocusSession.maxMinutes,
                size: UiSize.dial,
                onChanged: service.setMinutesFromDial,
                onDragStateChanged: (value) => setState(() => _isDragging = value),
                centre: _DialCentre(session: session, endsAt: service.endsAt()),
              ),
              const SizedBox(width: UiSize.xxxl),
              Expanded(child: _PresetsAndStart(session: session)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DialCentre extends StatelessWidget {
  const _DialCentre({required this.session, required this.endsAt});

  final FocusSession session;
  final DateTime? endsAt;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // `numPop` — the number pops on every five-minute snap, so it is keyed on minutes.
      _NumPop(
        key: ValueKey(session.minutes),
        child: Text(
          session.isOpenEnd
              ? context.translations.focus_session_open_end_symbol
              : Duration(seconds: session.secondsLeft).toCountdown,
          style: UiTypography.dialValue,
        ),
      ),
      UiSpacer.xxs,
      Text(
        endsAt == null
            ? context.translations.focus_session_no_end_time
            : context.translations.focus_session_ends_at(endsAt!.toWallClock),
        style: UiTypography.dialMeta,
      ),
    ],
  );
}

/// `numPop` — scale 1.07 → 1 over 220ms.
class _NumPop extends StatefulWidget {
  const _NumPop({required this.child, super.key});

  final Widget child;

  @override
  State<_NumPop> createState() => _NumPopState();
}

class _NumPopState extends State<_NumPop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.numPop)..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: CurvedAnimation(parent: _controller, curve: UiMotion.ease).drive(Tween(begin: 1.07, end: 1)),
    child: widget.child,
  );
}

class _PresetsAndStart extends ConsumerWidget {
  const _PresetsAndStart({required this.session});

  final FocusSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(focusSessionServiceProvider.notifier);
    final stats = ref.watch(focusStatsProvider).value ?? const FocusStats();
    // Falls back to just the built-in Open End preset while the database hasn't
    // responded yet, rather than showing an empty list for a moment.
    final presets = ref.watch(focusPresetsProvider).value ?? const [FocusPreset.openEnd];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final preset in presets) ...[
          _PresetRow(
            preset: preset,
            isSelected: preset.minutes == session.minutes,
            onTap: () => service.selectPreset(preset),
          ),
          if (preset != presets.last) UiSpacer.s,
        ],
        UiSpacer.ml,
        UiPrimaryButton(
          label: session.isRunning
              ? context.translations.focus_session_pause
              : context.translations.focus_session_start,
          padding: const EdgeInsets.symmetric(horizontal: UiSize.xl, vertical: UiSize.m),
          onPressed: () => session.isRunning ? service.pause() : service.start(),
        ),
        UiSpacer.s,
        Center(
          child: Text(
            context.translations.focus_session_stats(stats.blockedToday, stats.sessionsToday),
            style: UiTypography.statLine,
          ),
        ),
      ],
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({required this.preset, required this.isSelected, required this.onTap});

  final FocusPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = preset.isOpenEnd ? context.translations.focus_preset_open_end : preset.label;

    return UiHoverRegion(
      builder: (context, isHovered) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.ease,
          padding: const EdgeInsets.symmetric(horizontal: UiSize.ml, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? UiColor.bgAccent : UiColor.white,
            borderRadius: UiRadius.allM,
            border: Border.all(
              color: isSelected ? UiColor.primary : (isHovered ? UiColor.borderStrong : UiColor.border),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: UiTypography.preset.copyWith(color: isSelected ? UiColor.fgAccentHover : UiColor.fg),
              ),
              Text(
                preset.isOpenEnd
                    ? context.translations.focus_session_open_end_symbol
                    : context.translations.focus_preset_minutes(preset.minutes),
                style: UiTypography.preset.copyWith(color: isSelected ? UiColor.primary : UiColor.fgSubtle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
