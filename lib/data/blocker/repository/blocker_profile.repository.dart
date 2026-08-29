import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/mapper/blocker.entity_mapper.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';

part 'blocker_profile.repository.g.dart';

/// Reads and writes blocker profiles and their entries.
class BlockerProfileRepository {
  BlockerProfileRepository({required this.dao});

  final BlockerDao dao;

  static const BlockerProfileEntityMapper _mapper = BlockerProfileEntityMapper();

  Stream<List<BlockerProfile>> watchProfiles() => dao.watchProfiles().map((rows) => rows.map(_mapper.toModel).toList());

  Future<int> countProfiles() => dao.countProfiles();

  Future<int> createProfile({required String name, required List<BlockedItem> items}) async {
    final id = await dao.insertProfile(
      BlockerProfilesCompanion.insert(name: name, sortOrder: Value(await dao.countProfiles())),
    );
    await dao.replaceItems(id, _companions(id, items));
    return id;
  }

  Future<void> saveProfile({required int id, required String name, required List<BlockedItem> items}) async {
    await dao.updateProfileName(id, name);
    await dao.replaceItems(id, _companions(id, items));
  }

  Future<void> deleteProfile(int id) => dao.deleteProfile(id);

  /// Appends a single entry, as the blocker card's add row does.
  Future<void> addItem({required int profileId, required String name, required BlockedItemKind kind}) => dao.addItem(
    BlockedItemsCompanion.insert(profileId: profileId, name: name, kind: BlockedItemEntityMapper.kindToStorage(kind)),
  );

  /// Appends an app picked through the Finder picker, with its bundle id — as opposed
  /// to [addItem], which classifies free-typed text and never has one.
  Future<void> addApp({required int profileId, required String name, required String bundleId}) => dao.addItem(
    BlockedItemsCompanion.insert(
      profileId: profileId,
      name: name,
      kind: BlockedItemEntityMapper.kindToStorage(BlockedItemKind.app),
      bundleId: Value(bundleId),
    ),
  );

  /// Includes or excludes one entry for its profile.
  Future<void> setItemEnabled({required int itemId, required bool enabled}) =>
      dao.setItemEnabled(itemId, enabled: enabled);

  List<BlockedItemsCompanion> _companions(int profileId, List<BlockedItem> items) => [
    for (final (index, item) in items.indexed)
      BlockedItemsCompanion.insert(
        profileId: profileId,
        name: item.name,
        kind: BlockedItemEntityMapper.kindToStorage(item.kind),
        enabled: Value(item.enabled),
        sortOrder: Value(index),
        bundleId: Value(item.bundleId),
      ),
  ];
}

@Riverpod(keepAlive: true)
BlockerProfileRepository blockerProfileRepository(Ref ref) =>
    BlockerProfileRepository(dao: BlockerDao(ref.watch(appDatabaseProvider)));
