import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_settings.repository.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_preset.repository.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_settings.service.dart';
import 'package:workspace_flow/domain/focus/service/focus_preset.service.dart';
import 'package:workspace_flow/presentation/screens/settings/settings.controller.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  SettingsController controller() => container.read(settingsControllerProvider.notifier);

  setUp(() {
    database = createTestDatabase();
    container = createContainer(
      overrides: [
        blockerSettingsRepositoryProvider.overrideWithValue(BlockerSettingsRepository(dao: BlockerDao(database))),
        focusPresetRepositoryProvider.overrideWithValue(FocusPresetRepository(dao: FocusDao(database))),
      ],
    );
    // Riverpod 3 pauses a stream provider's subscription while nothing actively
    // listens to it — see the same workaround in blocker.service_test.dart.
    container.listen(blockerUnlockSettingsProvider, (_, _) {});
    container.listen(focusPresetsProvider, (_, _) {});
  });

  test('Given the database has the seeded defaults, '
      'when the controller builds, '
      'then the draft is loaded with them — including the three seeded presets, Open End excluded', () async {
    // When
    final state = await waitForProvider(
      () => container.read(settingsControllerProvider),
      (state) => state.isLoaded,
    );

    // Then
    expect(state.blockerUnlockMinutes, 2);
    expect(state.blockerUnlocksPerSession, 3);
    expect(state.focusPresets.map((preset) => preset.label), ['Pomodoro', 'Deep work', 'Long haul']);
  });

  test('Given the loaded draft, '
      'when a preset is added, edited and another removed, '
      'then the draft reflects exactly that — nothing is written until Save', () async {
    // Given
    await waitForProvider(() => container.read(settingsControllerProvider), (state) => state.isLoaded);

    // When
    controller()
      ..addPreset()
      ..setPresetLabel(3, 'Sprint')
      ..setPresetMinutes(3, 15)
      ..removePreset(0);

    // Then
    final state = container.read(settingsControllerProvider);
    expect(state.focusPresets.map((preset) => preset.label), ['Deep work', 'Long haul', 'Sprint']);
    expect(state.focusPresets.last.minutes, 15);

    // Nothing persisted yet
    final repository = FocusPresetRepository(dao: FocusDao(database));
    expect((await repository.watchPresets().first).map((preset) => preset.label), ['Pomodoro', 'Deep work', 'Long haul']);
  });

  test('Given edits to both the blocker allowance and the presets, '
      'when Save is called, '
      'then both are written to the database', () async {
    // Given
    await waitForProvider(() => container.read(settingsControllerProvider), (state) => state.isLoaded);
    controller()
      ..setUnlockMinutes(10)
      ..setUnlocksPerSession(1)
      ..setDefaultPreset(0);

    // When
    await controller().save();

    // Then
    final blockerSettings = BlockerSettingsRepository(dao: BlockerDao(database));
    final settings = await blockerSettings.watchSettings().first;
    expect(settings.unlockMinutes, 10);
    expect(settings.unlocksPerSession, 1);

    final presets = FocusPresetRepository(dao: FocusDao(database));
    final saved = await presets.watchPresets().first;
    expect(saved.singleWhere((preset) => preset.isDefault).label, 'Pomodoro');
  });
}
