import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_settings.repository.dart';

import '../../../database.test_util.dart';

void main() {
  late BlockerSettingsRepository repository;

  setUp(() {
    repository = BlockerSettingsRepository(dao: BlockerDao(createTestDatabase()));
  });

  test('Given a freshly created database, '
      'when the unlock allowance is read, '
      'then it already has the seeded defaults — the singleton row exists without a migration', () async {
    // When
    final settings = await repository.watchSettings().first;

    // Then
    expect(settings.unlockMinutes, 2);
    expect(settings.unlocksPerSession, 3);
  });

  test('Given a custom unlock allowance, '
      'when it is saved, '
      'then reading it back reflects the new values', () async {
    // Given / When
    await repository.save(unlockMinutes: 5, unlocksPerSession: 1);
    final settings = await repository.watchSettings().first;

    // Then
    expect(settings.unlockMinutes, 5);
    expect(settings.unlocksPerSession, 1);
  });
}
