import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';

void main() {
  late BlockerProfileRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = BlockerProfileRepository(dao: BlockerDao(createTestDatabase()));
    container = createContainer(overrides: [blockerProfileRepositoryProvider.overrideWithValue(repository)]);
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

  test('Given the add row, '
      'when a value containing a dot is entered, '
      'then it is stored as a site', () async {
    // Given
    final id = await repository.createProfile(name: 'Code', items: const []);

    // When
    await service().addEntry(profileId: id, raw: '  news.ycombinator.com  ');

    // Then — surrounding whitespace is trimmed, the dot makes it a site
    final profile = (await repository.watchProfiles().first).single;
    expect(profile.items.single.name, 'news.ycombinator.com');
    expect(profile.items.single.kind, BlockedItemKind.site);
  });

  test('Given the add row, '
      'when only whitespace is entered, '
      'then nothing is stored', () async {
    // Given
    final id = await repository.createProfile(name: 'Code', items: const []);

    // When
    await service().addEntry(profileId: id, raw: '   ');

    // Then
    expect((await repository.watchProfiles().first).single.items, isEmpty);
  });

  test('Given a picked app, '
      'when it is added, '
      'then it is stored as an app carrying its bundle id', () async {
    // Given
    final id = await repository.createProfile(name: 'Code', items: const []);

    // When
    await service().addApp(
      profileId: id,
      entry: const AppLibraryEntry(name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap'),
    );

    // Then
    final item = (await repository.watchProfiles().first).single.items.single;
    expect(item.kind, BlockedItemKind.app);
    expect(item.bundleId, 'com.tinyspeck.slackmacgap');
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
