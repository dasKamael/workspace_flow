import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

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

  /// The apps and websites this project's layout actually uses, synthesised from its
  /// windows rather than read from the shared library.
  ///
  /// The shared library can lose an entry — removed by hand, or never added in the
  /// first place by an older seed — without the project's own windows being touched;
  /// they carry their own copy of the app's fields. Without this, the editor's "Apps &
  /// websites" panel would look like it forgot an app the layout still visibly uses.
  List<AppLibraryEntry> get windowEntries => [
    for (final window in windows)
      if (window.name.trim().isNotEmpty)
        AppLibraryEntry(
          name: window.name,
          bundleId: window.bundleId,
          url: window.url,
          documentPath: window.documentPath,
        ),
  ];
}
