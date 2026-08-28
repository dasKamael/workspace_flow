import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';

part 'blocker_profile.service.g.dart';

/// Thrown when the last remaining profile would be deleted.
///
/// The design disables the delete action in that case; the service refuses as well so
/// the rule holds no matter which path reaches it.
class LastProfileException implements Exception {
  const LastProfileException();

  @override
  String toString() => 'The last blocker profile cannot be deleted';
}

/// All blocker profiles, kept in sync with the database.
@Riverpod(keepAlive: true)
Stream<List<BlockerProfile>> blockerProfiles(Ref ref) => ref.watch(blockerProfileRepositoryProvider).watchProfiles();

/// Which profile the blocker card is showing.
@Riverpod(keepAlive: true)
class SelectedProfileService extends _$SelectedProfileService {
  @override
  int? build() => null;

  void select(int profileId) => state = profileId;
}

/// The profile the blocker card is showing.
///
/// Derived for the same reason as [selectedProject]: watching the notifier does not
/// rebuild on a selection change.
@Riverpod(keepAlive: true)
BlockerProfile? selectedProfile(Ref ref) {
  final profiles = ref.watch(blockerProfilesProvider).valueOrNull ?? const <BlockerProfile>[];
  if (profiles.isEmpty) return null;

  final selectedId = ref.watch(selectedProfileServiceProvider);
  return profiles.where((profile) => profile.id == selectedId).firstOrNull ?? profiles.first;
}

/// Creating, saving and deleting profiles, and toggling single entries.
@Riverpod(keepAlive: true)
class BlockerProfileService extends _$BlockerProfileService {
  @override
  void build() {}

  Future<int> create({required String name, required List<BlockedItem> items}) =>
      ref.read(blockerProfileRepositoryProvider).createProfile(name: name, items: items);

  Future<void> save({required int id, required String name, required List<BlockedItem> items}) =>
      ref.read(blockerProfileRepositoryProvider).saveProfile(id: id, name: name, items: items);

  /// Deletes a profile unless it is the last one.
  Future<void> delete(int id) async {
    final repository = ref.read(blockerProfileRepositoryProvider);
    if (await repository.countProfiles() <= 1) throw const LastProfileException();
    await repository.deleteProfile(id);
  }

  /// Adds an entry from the card's add row. A value containing a dot becomes a site.
  Future<void> addEntry({required int profileId, required String raw}) async {
    final name = raw.trim();
    if (name.isEmpty) return;
    await ref
        .read(blockerProfileRepositoryProvider)
        .addItem(profileId: profileId, name: name, kind: BlockedItemKind.fromInput(name));
  }

  /// Includes or excludes one entry for its profile.
  Future<void> toggleItem(BlockedItem item) =>
      ref.read(blockerProfileRepositoryProvider).setItemEnabled(itemId: item.id, enabled: !item.enabled);
}
