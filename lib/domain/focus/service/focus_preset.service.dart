import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/focus/repository/focus_preset.repository.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';

part 'focus_preset.service.g.dart';

/// All focus presets, kept in sync with the database, with the built-in "Open end"
/// preset always appended last.
@Riverpod(keepAlive: true)
Stream<List<FocusPreset>> focusPresets(Ref ref) =>
    ref.watch(focusPresetRepositoryProvider).watchPresets().map((presets) => [...presets, FocusPreset.openEnd]);

/// Saving the preset list — separate from the stream above for the same reason
/// [BlockerSettingsService] sits next to `blockerUnlockSettingsProvider`.
@Riverpod(keepAlive: true)
class FocusPresetService extends _$FocusPresetService {
  @override
  void build() {}

  Future<void> savePresets(List<FocusPreset> presets) => ref.read(focusPresetRepositoryProvider).savePresets(presets);
}
