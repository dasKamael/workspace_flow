import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/system/app_icons.util.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

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

/// Icons for a given set of bundle ids, keyed by bundle id — lets the profile
/// editor's rows show the real app icon instead of just a generic glyph.
///
/// Takes the bundle ids as a parameter rather than reading them off a saved profile,
/// since a row can name an app just picked in the editor's own unsaved draft.
@riverpod
Future<Map<String, Uint8List>> blockerItemIcons(Ref ref, List<String?> bundleIds) =>
    AppIconsUtil.fetch(ref.read(appLauncherRepositoryProvider), bundleIds);

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
  final profiles = ref.watch(blockerProfilesProvider).value ?? const <BlockerProfile>[];
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

  /// Opens the Finder picker without persisting anything — adding an app only happens
  /// through the profile editor's draft, which writes to the database on Save.
  Future<AppLibraryEntry?> pickApp() async {
    try {
      return await ref.read(appLauncherRepositoryProvider).chooseApp();
    } on Object {
      return null;
    }
  }

  /// Includes or excludes one entry for its profile.
  Future<void> toggleItem(BlockedItem item) =>
      ref.read(blockerProfileRepositoryProvider).setItemEnabled(itemId: item.id, enabled: !item.enabled);
}
