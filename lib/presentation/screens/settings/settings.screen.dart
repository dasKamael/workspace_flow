import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';
import 'package:workspace_flow/domain/system/service/login_item.service.dart';
import 'package:workspace_flow/domain/system/service/permission.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_link_label.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_switch.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_text_field.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_tick_box.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_sheet.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/screens/settings/settings.controller.dart';

/// The settings sheet: login item, accessibility status, the blocker's unlock
/// allowance, and the focus presets — one singleton screen, no id parameter.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _unlockMinutesController = TextEditingController();
  final TextEditingController _unlocksPerSessionController = TextEditingController();
  final Map<int, TextEditingController> _presetLabelControllers = {};
  final Map<int, TextEditingController> _presetMinutesControllers = {};
  bool _didPrefill = false;

  @override
  void dispose() {
    _unlockMinutesController.dispose();
    _unlocksPerSessionController.dispose();
    for (final controller in _presetLabelControllers.values) {
      controller.dispose();
    }
    for (final controller in _presetMinutesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  SettingsController get _controller => ref.read(settingsControllerProvider.notifier);

  void _close() => context.goNamed(UiRoute.workspace.name);

  Future<void> _save() async {
    await _controller.save();
    if (mounted) _close();
  }

  /// One controller per row, keyed by the draft id so a row keeps its text across
  /// rebuilds — mirrors the profile editor's entry rows.
  TextEditingController _labelController(FocusPreset preset) =>
      _presetLabelControllers.putIfAbsent(preset.id!, () => TextEditingController(text: preset.label));

  TextEditingController _minutesController(FocusPreset preset) => _presetMinutesControllers.putIfAbsent(
    preset.id!,
    () => TextEditingController(text: preset.minutes.toString()),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsControllerProvider);
    final loginItemEnabled = ref.watch(loginItemServiceProvider).value ?? false;
    final hasAccessibility = ref.watch(accessibilityPermissionServiceProvider).value ?? false;

    if (state.isLoaded && !_didPrefill) {
      _didPrefill = true;
      _unlockMinutesController.text = state.blockerUnlockMinutes.toString();
      _unlocksPerSessionController.text = state.blockerUnlocksPerSession.toString();
    }

    return UiSheet(
      width: UiSize.sheetNarrow,
      onDismiss: _close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.translations.settings_eyebrow.toUpperCase(), style: UiTypography.eyebrow),
          UiSpacer.s,
          Text(context.translations.settings_title, style: UiTypography.headline),
          UiSpacer.xl,

          // General
          Row(
            children: [
              Expanded(
                child: Text(context.translations.settings_login_item_label, style: UiTypography.cardLabel),
              ),
              UiSwitch(
                value: loginItemEnabled,
                onChanged: (value) => ref.read(loginItemServiceProvider.notifier).setEnabled(enabled: value),
              ),
            ],
          ),
          UiSpacer.m,
          Row(
            children: [
              Expanded(
                child: Text(context.translations.settings_accessibility_label, style: UiTypography.cardLabel),
              ),
              Text(
                hasAccessibility
                    ? context.translations.settings_accessibility_granted
                    : context.translations.settings_accessibility_not_granted,
                style: UiTypography.hint,
              ),
              if (!hasAccessibility) ...[
                UiSpacer.s,
                UiLinkLabel(
                  label: context.translations.settings_accessibility_action,
                  onTap: () => ref.read(accessibilityPermissionServiceProvider.notifier).request(),
                ),
              ],
            ],
          ),
          UiSpacer.xxl,
          const SizedBox(height: 1, child: ColoredBox(color: UiColor.border)),
          UiSpacer.xl,

          // Blocker unlock allowance
          Text(context.translations.settings_blocker_section_label.toUpperCase(), style: UiTypography.cardLabel),
          UiSpacer.m,
          Row(
            children: [
              Expanded(
                child: _LabeledField(
                  label: context.translations.settings_blocker_unlock_minutes_label,
                  controller: _unlockMinutesController,
                  onChanged: (value) => _controller.setUnlockMinutes(int.tryParse(value) ?? state.blockerUnlockMinutes),
                ),
              ),
              UiSpacer.m,
              Expanded(
                child: _LabeledField(
                  label: context.translations.settings_blocker_unlocks_per_session_label,
                  controller: _unlocksPerSessionController,
                  onChanged: (value) =>
                      _controller.setUnlocksPerSession(int.tryParse(value) ?? state.blockerUnlocksPerSession),
                ),
              ),
            ],
          ),
          UiSpacer.xxl,
          const SizedBox(height: 1, child: ColoredBox(color: UiColor.border)),
          UiSpacer.xl,

          // Focus presets
          Text(context.translations.settings_focus_presets_section_label.toUpperCase(), style: UiTypography.cardLabel),
          UiSpacer.m,
          for (final (index, preset) in state.focusPresets.indexed) ...[
            _PresetRow(
              key: ValueKey(preset.id),
              labelController: _labelController(preset),
              minutesController: _minutesController(preset),
              isDefault: preset.isDefault,
              onLabelChanged: (value) => _controller.setPresetLabel(index, value),
              onMinutesChanged: (value) => _controller.setPresetMinutes(index, int.tryParse(value) ?? preset.minutes),
              onSetDefault: () => _controller.setDefaultPreset(index),
              onRemove: () => _controller.removePreset(index),
            ),
            UiSpacer.s,
          ],
          UiSpacer.s,
          UiLinkLabel(label: context.translations.settings_focus_presets_add, onTap: _controller.addPreset),
          UiSpacer.xl,
          const SizedBox(height: 1, child: ColoredBox(color: UiColor.border)),
          UiSpacer.l,
          Row(
            children: [
              UiPrimaryButton(label: context.translations.common_save, onPressed: _save),
              UiSpacer.sm,
              UiGhostButton(label: context.translations.common_cancel, onPressed: _close),
            ],
          ),
        ],
      ),
    );
  }
}

/// A small labeled numeric field — the two blocker allowance fields side by side.
class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.controller, required this.onChanged});

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: UiTypography.hint),
      UiSpacer.xs,
      UiTextField(
        controller: controller,
        onChanged: onChanged,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    ],
  );
}

/// One editable preset: label, minutes, a "default" toggle, and a remove button.
class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.labelController,
    required this.minutesController,
    required this.isDefault,
    required this.onLabelChanged,
    required this.onMinutesChanged,
    required this.onSetDefault,
    required this.onRemove,
    super.key,
  });

  final TextEditingController labelController;
  final TextEditingController minutesController;
  final bool isDefault;
  final ValueChanged<String> onLabelChanged;
  final ValueChanged<String> onMinutesChanged;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: UiTextField(
          controller: labelController,
          placeholder: context.translations.settings_focus_presets_label_placeholder,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          onChanged: onLabelChanged,
        ),
      ),
      UiSpacer.s,
      SizedBox(
        width: UiSize.xxxl * 2,
        child: UiTextField(
          controller: minutesController,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onMinutesChanged,
        ),
      ),
      UiSpacer.s,
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onSetDefault,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UiTickBox(checked: isDefault),
              UiSpacer.xs,
              Text(context.translations.settings_focus_presets_default_hint, style: UiTypography.hint),
            ],
          ),
        ),
      ),
      UiSpacer.s,
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onRemove,
          child: const SizedBox.square(
            dimension: UiSize.xl,
            child: Center(child: UiSvgIcon(path: UiIcon.xMark, size: 12, color: UiColor.fgSubtle, strokeWidth: 2)),
          ),
        ),
      ),
    ],
  );
}
