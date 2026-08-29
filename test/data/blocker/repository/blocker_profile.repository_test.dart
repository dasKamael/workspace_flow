import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';

import '../../../database.test_util.dart';

void main() {
  late BlockerProfileRepository repository;

  BlockedItem item(String name, {bool enabled = true}) =>
      BlockedItem(id: 0, name: name, kind: BlockedItemKind.fromInput(name), enabled: enabled);

  setUp(() {
    repository = BlockerProfileRepository(dao: BlockerDao(createTestDatabase()));
  });

  test('Given a profile with a site and an app, '
      'when it is read back, '
      'then each entry keeps the kind it was classified as', () async {
    // Given / When
    await repository.createProfile(name: 'Deep Work', items: [item('youtube.com'), item('Slack')]);
    final profiles = await repository.watchProfiles().first;

    // Then — a value containing a dot is a site, everything else an app
    expect(profiles.single.items.map((i) => i.kind), [BlockedItemKind.site, BlockedItemKind.app]);
  });

  test('Given a profile with one excluded entry, '
      'when its enforced entries are read, '
      'then the excluded one is left out but still stored', () async {
    // Given
    await repository.createProfile(name: 'Code', items: [item('x.com'), item('Slack', enabled: false)]);

    // When
    final profile = (await repository.watchProfiles().first).single;

    // Then
    expect(profile.items, hasLength(2));
    expect(profile.enabledItems.map((i) => i.name), ['x.com']);
  });

  test('Given a stored entry, '
      'when it is toggled, '
      'then only that entry changes', () async {
    // Given
    await repository.createProfile(name: 'Code', items: [item('x.com'), item('Slack')]);
    final before = (await repository.watchProfiles().first).single;

    // When
    await repository.setItemEnabled(itemId: before.items.first.id, enabled: false);

    // Then
    final after = (await repository.watchProfiles().first).single;
    expect(after.items.first.enabled, isFalse);
    expect(after.items.last.enabled, isTrue);
  });

  test('Given a profile, '
      'when an entry is appended from the card\'s add row, '
      'then it joins the existing entries', () async {
    // Given
    final id = await repository.createProfile(name: 'Admin light', items: [item('Messages')]);

    // When
    await repository.addItem(profileId: id, name: 'reddit.com', kind: BlockedItemKind.site);

    // Then
    final profile = (await repository.watchProfiles().first).single;
    expect(profile.items.map((i) => i.name), ['Messages', 'reddit.com']);
  });

  test('Given a profile, '
      'when an app is added through the Finder picker, '
      'then it is stored as an app with its bundle id', () async {
    // Given
    final id = await repository.createProfile(name: 'Deep Work', items: []);

    // When
    await repository.addApp(profileId: id, name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap');

    // Then
    final profile = (await repository.watchProfiles().first).single;
    expect(profile.items.single.kind, BlockedItemKind.app);
    expect(profile.items.single.bundleId, 'com.tinyspeck.slackmacgap');
  });

  test('Given a profile with entries, '
      'when the profile is deleted, '
      'then its entries go with it', () async {
    // Given
    final id = await repository.createProfile(name: 'Code', items: [item('x.com')]);

    // When
    await repository.deleteProfile(id);

    // Then
    expect(await repository.watchProfiles().first, isEmpty);
    expect(await repository.countProfiles(), 0);
  });
}
