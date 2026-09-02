import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_settings.service.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';
import 'package:workspace_flow/domain/focus/service/focus_preset.service.dart';
import 'package:workspace_flow/presentation/screens/settings/settings.state.dart';

part 'settings.controller.g.dart';

/// Drives the settings sheet's draft — the blocker's unlock allowance and the focus
/// presets. Login item and Accessibility status apply immediately and are not part of
/// this draft; see [SettingsScreen].
@riverpod
class SettingsController extends _$SettingsController {
  @override
  SettingsState build() {
    final settings = ref.watch(blockerUnlockSettingsProvider).value;
    final presets = ref.watch(focusPresetsProvider).value?.where((preset) => !preset.isOpenEnd).toList();
    if (settings == null || presets == null) return const SettingsState();

    return SettingsState(
      blockerUnlockMinutes: settings.unlockMinutes,
      blockerUnlocksPerSession: settings.unlocksPerSession,
      focusPresets: presets,
      isLoaded: true,
    );
  }

  void setUnlockMinutes(int minutes) => state = state.copyWith(blockerUnlockMinutes: minutes.clamp(1, 60));

  void setUnlocksPerSession(int count) => state = state.copyWith(blockerUnlocksPerSession: count.clamp(0, 20));

  /// Appends a blank draft row — a negative id, like every other draft entry in the
  /// app, so it never collides with a stored row before Save assigns a real one.
  void addPreset() => state = state.copyWith(
    focusPresets: [
      ...state.focusPresets,
      FocusPreset(id: -(state.focusPresets.length + 1), label: '', minutes: kFocusDefaultMinutes),
    ],
  );

  void setPresetLabel(int index, String label) => _patchPreset(index, (preset) => preset.copyWith(label: label));

  void setPresetMinutes(int index, int minutes) => _patchPreset(
    index,
    (preset) => preset.copyWith(minutes: minutes.clamp(kFocusMinMinutes, kFocusMaxMinutes)),
  );

  /// Marks [index] as the preset the app starts on — exactly one at a time.
  void setDefaultPreset(int index) => state = state.copyWith(
    focusPresets: [for (final (i, preset) in state.focusPresets.indexed) preset.copyWith(isDefault: i == index)],
  );

  void removePreset(int index) {
    final presets = [...state.focusPresets]..removeAt(index);
    state = state.copyWith(focusPresets: presets);
  }

  Future<void> save() async {
    await ref
        .read(blockerSettingsServiceProvider.notifier)
        .save(unlockMinutes: state.blockerUnlockMinutes, unlocksPerSession: state.blockerUnlocksPerSession);

    final presets = state.focusPresets.where((preset) => preset.label.trim().isNotEmpty).toList();
    await ref.read(focusPresetServiceProvider.notifier).savePresets(presets);
  }

  void _patchPreset(int index, FocusPreset Function(FocusPreset preset) patch) {
    if (index < 0 || index >= state.focusPresets.length) return;
    final presets = [...state.focusPresets];
    presets[index] = patch(presets[index]);
    state = state.copyWith(focusPresets: presets);
  }
}
