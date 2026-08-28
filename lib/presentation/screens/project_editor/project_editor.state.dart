import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';

part 'project_editor.state.freezed.dart';

/// The editor's draft. Nothing is written until Save.
@freezed
abstract class ProjectEditorState with _$ProjectEditorState {
  const factory ProjectEditorState({
    @Default('') String name,
    @Default([]) List<ProjectWindow> windows,

    /// Null while creating a new project.
    int? projectId,
    @Default(false) bool isLoaded,
  }) = _ProjectEditorState;

  const ProjectEditorState._();

  bool get isNew => projectId == null;
}
