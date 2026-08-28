import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/layout_overlay.service.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/project/service/window_capture.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.state.dart';

part 'project_editor.controller.g.dart';

/// Drives the project editor sheet.
///
/// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
@riverpod
class ProjectEditorController extends _$ProjectEditorController {
  @override
  ProjectEditorState build(int? projectId) {
    if (projectId == null) return const ProjectEditorState(isLoaded: true);

    final project = ref.watch(projectsProvider).valueOrNull?.where((project) => project.id == projectId).firstOrNull;

    if (project == null) return ProjectEditorState(projectId: projectId);

    return ProjectEditorState(projectId: project.id, name: project.name, windows: project.windows, isLoaded: true);
  }

  void setName(String name) => state = state.copyWith(name: name);

  /// Drops every window in the draft that matches [entry].
  ///
  /// Used for a chip in "Apps & websites" that has no backing library row — it exists
  /// purely because the project's own layout uses it, so the only sensible thing its ×
  /// can do is take it out of this project. Only the draft changes; nothing is written
  /// until Save.
  void removeWindowsMatching(AppLibraryEntry entry) {
    final windows = state.windows.where((window) => window.libraryKey != entry.key).toList();
    state = state.copyWith(windows: windows);
  }

  /// Places [entry] on [screenIndex], centred on the drop position.
  ///
  /// Only the website field reaches this now — apps are dropped in from inside the
  /// full-size overlay, where one can see where they land.
  void place({required AppLibraryEntry entry, required int screenIndex, required double x, required double y}) {
    final window = ProjectWindow.fromDrop(
      // Draft ids are negative so they never collide with persisted rows.
      id: -(state.windows.length + 1),
      name: entry.name,
      bundleId: entry.bundleId,
      url: entry.url,
      documentPath: entry.documentPath,
      screenIndex: screenIndex,
      x: x,
      y: y,
    );
    state = state.copyWith(windows: [...state.windows, window]);
  }

  /// Replaces the draft with the windows that are open right now.
  ///
  /// Returns false when nothing could be read — no permission, or nothing worth
  /// capturing — and leaves the draft untouched in that case.
  Future<bool> captureCurrentArrangement() async {
    final captured = await ref.read(windowCaptureServiceProvider.notifier).capture();
    if (captured.isEmpty) return false;

    // The captured apps become chips too, so they can be re-added after a change of mind.
    final projects = ref.read(projectServiceProvider.notifier);
    for (final window in captured) {
      await projects.addToLibrary(AppLibraryEntry(name: window.name, bundleId: window.bundleId));
    }

    state = state.copyWith(windows: captured);
    return true;
  }

  /// Hands the draft to the full-size overlay on the real screens and takes back what
  /// comes out of it. Returns false when the overlay was cancelled or unavailable.
  Future<bool> arrangeOnScreen() async {
    final arranged = await ref.read(layoutOverlayServiceProvider.notifier).edit(state.windows);
    if (arranged == null) return false;

    state = state.copyWith(windows: arranged);
    return true;
  }

  Future<void> save({required String fallbackName}) async {
    final name = state.name.trim().isEmpty ? fallbackName : state.name.trim();
    final windows = state.windows.where((window) => window.name.trim().isNotEmpty).toList();
    final service = ref.read(projectServiceProvider.notifier);

    if (state.projectId case final int id) {
      await service.save(id: id, name: name, windows: windows);
    } else {
      await service.create(name: name, windows: windows);
    }
  }

  Future<void> delete() async {
    if (state.projectId case final int id) await ref.read(projectServiceProvider.notifier).delete(id);
  }
}
