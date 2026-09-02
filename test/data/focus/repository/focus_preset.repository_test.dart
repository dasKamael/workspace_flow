import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_preset.repository.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';

import '../../../database.test_util.dart';

void main() {
  late FocusPresetRepository repository;

  setUp(() {
    repository = FocusPresetRepository(dao: FocusDao(createTestDatabase()));
  });

  test('Given a freshly created database, '
      'when the presets are read, '
      'then the three seeded presets are already there, in order, with Deep work marked default — '
      'the singleton row exists without a migration', () async {
    // When
    final presets = await repository.watchPresets().first;

    // Then
    expect(presets.map((preset) => preset.label), ['Pomodoro', 'Deep work', 'Long haul']);
    expect(presets.map((preset) => preset.minutes), [25, 50, 90]);
    expect(presets.map((preset) => preset.isDefault), [false, true, false]);
  });

  test('Given a new preset list, '
      'when it is saved, '
      'then reading it back replaces the old list entirely, in the order given', () async {
    // Given / When
    await repository.savePresets(const [
      FocusPreset(label: 'Sprint', minutes: 15),
      FocusPreset(label: 'Marathon', minutes: 120, isDefault: true),
    ]);
    final presets = await repository.watchPresets().first;

    // Then
    expect(presets.map((preset) => preset.label), ['Sprint', 'Marathon']);
    expect(presets.map((preset) => preset.isDefault), [false, true]);
  });
}
