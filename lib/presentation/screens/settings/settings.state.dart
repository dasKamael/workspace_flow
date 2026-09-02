import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';

part 'settings.state.freezed.dart';

/// The settings sheet's draft. Nothing is written until Save.
@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    // Matches kBlockerUnlockDuration/kBlockerUnlocksPerSession — a Duration getter
    // isn't a valid const default, so these are spelled out as literals.
    @Default(2) int blockerUnlockMinutes,
    @Default(3) int blockerUnlocksPerSession,

    /// Editable presets only — the built-in Open End preset never appears here.
    @Default([]) List<FocusPreset> focusPresets,
    @Default(false) bool isLoaded,
  }) = _SettingsState;
}
