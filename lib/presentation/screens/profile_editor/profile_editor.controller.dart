import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/presentation/screens/profile_editor/profile_editor.state.dart';

part 'profile_editor.controller.g.dart';

/// Drives the blocker profile editor sheet.
@riverpod
class ProfileEditorController extends _$ProfileEditorController {
  @override
  ProfileEditorState build(int? profileId) {
    final profiles = ref.watch(blockerProfilesProvider).valueOrNull ?? const [];
    final canDelete = profiles.length > 1;

    if (profileId == null) return ProfileEditorState(isLoaded: true, canDelete: false);

    final profile = profiles.where((profile) => profile.id == profileId).firstOrNull;
    if (profile == null) return ProfileEditorState(profileId: profileId, canDelete: canDelete);

    return ProfileEditorState(
      profileId: profile.id,
      name: profile.name,
      items: profile.items,
      isLoaded: true,
      canDelete: canDelete,
    );
  }

  void setName(String name) => state = state.copyWith(name: name);

  /// Adds an empty row for the user to type into.
  void addEntry() => state = state.copyWith(
    items: [
      ...state.items,
      BlockedItem(id: -(state.items.length + 1), name: '', kind: BlockedItemKind.app),
    ],
  );

  void setEntryName(int index, String name) => _patch(index, (item) => item.copyWith(name: name));

  /// Flips a row between "site" and "app" via its pill button.
  void toggleKind(int index) => _patch(
    index,
    (item) => item.copyWith(kind: item.kind == BlockedItemKind.site ? BlockedItemKind.app : BlockedItemKind.site),
  );

  void removeEntry(int index) {
    final items = [...state.items]..removeAt(index);
    state = state.copyWith(items: items);
  }

  /// Saves the draft. Empty name becomes [fallbackName]; unnamed rows are dropped.
  Future<void> save({required String fallbackName}) async {
    final name = state.name.trim().isEmpty ? fallbackName : state.name.trim();
    final items = state.items.where((item) => item.name.trim().isNotEmpty).toList();
    final service = ref.read(blockerProfileServiceProvider.notifier);

    if (state.profileId case final int id) {
      await service.save(id: id, name: name, items: items);
    } else {
      await service.create(name: name, items: items);
    }
    await ref.read(blockerServiceProvider.notifier).reapply();
  }

  Future<void> delete() async {
    if (state.profileId case final int id) await ref.read(blockerProfileServiceProvider.notifier).delete(id);
  }

  void _patch(int index, BlockedItem Function(BlockedItem item) patch) {
    if (index < 0 || index >= state.items.length) return;
    final items = [...state.items];
    items[index] = patch(items[index]);
    state = state.copyWith(items: items);
  }
}
