import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/common/mapper/entity_mapper.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';

/// Maps a profile row plus its item rows onto the domain [BlockerProfile].
class BlockerProfileEntityMapper
    implements EntityMapper<BlockerProfile, ({BlockerProfileEntity profile, List<BlockedItemEntity> items})> {
  const BlockerProfileEntityMapper();

  static const BlockedItemEntityMapper itemMapper = BlockedItemEntityMapper();

  @override
  BlockerProfile toModel(({BlockerProfileEntity profile, List<BlockedItemEntity> items}) entity) => BlockerProfile(
    id: entity.profile.id,
    name: entity.profile.name,
    sortOrder: entity.profile.sortOrder,
    items: entity.items.map(itemMapper.toModel).toList(),
  );

  @override
  ({BlockerProfileEntity profile, List<BlockedItemEntity> items}) toEntity(BlockerProfile model) =>
      throw UnimplementedError('A profile is persisted through BlockerProfileRepository.saveProfile');
}

class BlockedItemEntityMapper implements EntityMapper<BlockedItem, BlockedItemEntity> {
  const BlockedItemEntityMapper();

  @override
  BlockedItem toModel(BlockedItemEntity entity) =>
      BlockedItem(id: entity.id, name: entity.name, kind: kindFromStorage(entity.kind), enabled: entity.enabled);

  /// Reads the persisted representation. Unknown values fall back to
  /// [BlockedItemKind.app] so a future kind never makes a profile unreadable.
  static BlockedItemKind kindFromStorage(String value) =>
      BlockedItemKind.values.firstWhere((kind) => kind.name == value, orElse: () => BlockedItemKind.app);

  /// The persisted representation of [kind].
  static String kindToStorage(BlockedItemKind kind) => kind.name;

  @override
  BlockedItemEntity toEntity(BlockedItem model) =>
      throw UnimplementedError('Item rows are written as companions by BlockerProfileRepository.saveProfile');
}
