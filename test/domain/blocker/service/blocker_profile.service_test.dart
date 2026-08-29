import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

import '../../../database.test_util.dart';
import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

void main() {
  late BlockerProfileRepository repository;
  late MockAppLauncherRepository launcher;
  late ProviderContainer container;

  setUp(() {
    repository = BlockerProfileRepository(dao: BlockerDao(createTestDatabase()));
    launcher = MockAppLauncherRepository();
    container = createContainer(
      overrides: [
        blockerProfileRepositoryProvider.overrideWithValue(repository),
        appLauncherRepositoryProvider.overrideWithValue(launcher),
      ],
    );
  });

  BlockerProfileService service() => container.read(blockerProfileServiceProvider.notifier);

  test('Given two profiles, '
      'when one is deleted, '
      'then it is removed', () async {
    // Given
    final first = await repository.createProfile(name: 'Deep Work', items: const []);
    await repository.createProfile(name: 'Code', items: const []);

    // When
    await service().delete(first);

    // Then
    expect((await repository.watchProfiles().first).map((p) => p.name), ['Code']);
  });

  test('Given a single remaining profile, '
      'when it is deleted, '
      'then the service refuses and the profile survives', () async {
    // Given
    final only = await repository.createProfile(name: 'Deep Work', items: const []);

    // When / Then — the design disables the action; the service enforces it as well
    await expectLater(service().delete(only), throwsA(isA<LastProfileException>()));
    expect(await repository.countProfiles(), 1);
  });

  test('Given the Finder picker returns an app, '
      'when it is picked, '
      'then the entry is returned without being persisted — the profile editor\'s '
      'draft decides what actually gets saved', () async {
    // Given
    when(
      launcher.chooseApp,
    ).thenAnswer((_) async => const AppLibraryEntry(name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap'));

    // When
    final entry = await service().pickApp();

    // Then
    expect(entry, const AppLibraryEntry(name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap'));
  });

  test('Given the Finder picker is cancelled or fails, '
      'when it is picked, '
      'then null is returned rather than throwing', () async {
    // Given
    when(launcher.chooseApp).thenThrow(Exception('boom'));

    // When / Then
    expect(await service().pickApp(), isNull);
  });

  test('Given an enabled entry, '
      'when it is toggled, '
      'then it is excluded from enforcement without being deleted', () async {
    // Given
    await repository.createProfile(
      name: 'Code',
      items: [const BlockedItem(id: 0, name: 'Slack', kind: BlockedItemKind.app)],
    );
    final stored = (await repository.watchProfiles().first).single.items.single;

    // When
    await service().toggleItem(stored);

    // Then
    final profile = (await repository.watchProfiles().first).single;
    expect(profile.items.single.enabled, isFalse);
    expect(profile.enabledItems, isEmpty);
  });
}
