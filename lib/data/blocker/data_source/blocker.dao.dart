import 'package:drift/drift.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/blocker/data_source/entity/blocker.tables.dart';

part 'blocker.dao.g.dart';

/// Database access for blocker profiles and their entries.
@DriftAccessor(tables: [BlockerProfiles, BlockedItems])
class BlockerDao extends DatabaseAccessor<AppDatabase> with _$BlockerDaoMixin {
  BlockerDao(super.db);

  Stream<List<({BlockerProfileEntity profile, List<BlockedItemEntity> items})>> watchProfiles() {
    final query = select(blockerProfiles)
      ..orderBy([(p) => OrderingTerm(expression: p.sortOrder), (p) => OrderingTerm(expression: p.id)]);

    return query.watch().asyncMap((rows) async {
      final itemsByProfile = await _itemsByProfile(rows.map((row) => row.id).toList());
      return rows.map((row) => (profile: row, items: itemsByProfile[row.id] ?? const [])).toList();
    });
  }

  Future<Map<int, List<BlockedItemEntity>>> _itemsByProfile(List<int> profileIds) async {
    if (profileIds.isEmpty) return {};

    final query = select(blockedItems)
      ..where((i) => i.profileId.isIn(profileIds))
      ..orderBy([(i) => OrderingTerm(expression: i.sortOrder), (i) => OrderingTerm(expression: i.id)]);

    final rows = await query.get();
    final grouped = <int, List<BlockedItemEntity>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.profileId, () => []).add(row);
    }
    return grouped;
  }

  Future<int> insertProfile(BlockerProfilesCompanion profile) => into(blockerProfiles).insert(profile);

  Future<void> updateProfileName(int id, String name) =>
      (update(blockerProfiles)..where((p) => p.id.equals(id))).write(BlockerProfilesCompanion(name: Value(name)));

  Future<void> deleteProfile(int id) => (delete(blockerProfiles)..where((p) => p.id.equals(id))).go();

  Future<int> countProfiles() async {
    final count = blockerProfiles.id.count();
    final row = await (selectOnly(blockerProfiles)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  /// Replaces the entries of [profileId] in one transaction (the editor saves a draft).
  Future<void> replaceItems(int profileId, List<BlockedItemsCompanion> items) => transaction(() async {
    await (delete(blockedItems)..where((i) => i.profileId.equals(profileId))).go();
    await batch((batch) => batch.insertAll(blockedItems, items));
  });

  /// Toggles whether a single entry is enforced.
  Future<void> setItemEnabled(int itemId, {required bool enabled}) =>
      (update(blockedItems)..where((i) => i.id.equals(itemId))).write(BlockedItemsCompanion(enabled: Value(enabled)));
}
