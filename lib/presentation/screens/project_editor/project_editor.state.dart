import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';

part 'project_editor.state.freezed.dart';

/// The editor's draft. Nothing is written until Save.
@freezed
abstract class ProjectEditorState with _$ProjectEditorState {
  const factory ProjectEditorState({
    @Default('') String name,
    @Default([]) List<ProjectWindow> windows,

    /// Index of the selected tile, or null.
    int? selectedIndex,

    /// Index of the tile currently being dragged or resized, or null.
    int? draggingIndex,

    /// Percent positions of the magnets the dragged tile is currently sitting on.
    /// Drawn as alignment guides, and cleared the moment the drag ends.
    @Default([]) List<double> guidesX,
    @Default([]) List<double> guidesY,

    /// Null while creating a new project.
    int? projectId,
    @Default(false) bool isLoaded,
  }) = _ProjectEditorState;

  const ProjectEditorState._();

  bool get isNew => projectId == null;

  /// Identities already placed, so the library chips can grey themselves out.
  Set<String> get placedKeys => windows.map((window) => window.url ?? window.bundleId ?? window.name).toSet();
}
