import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';

part 'profile_editor.state.freezed.dart';

/// The blocker profile editor's draft.
@freezed
abstract class ProfileEditorState with _$ProfileEditorState {
  const factory ProfileEditorState({
    @Default('') String name,
    @Default([]) List<BlockedItem> items,
    int? profileId,
    @Default(false) bool isLoaded,

    /// Deleting is blocked while only one profile exists.
    @Default(false) bool canDelete,
  }) = _ProfileEditorState;

  const ProfileEditorState._();

  bool get isNew => profileId == null;
}
