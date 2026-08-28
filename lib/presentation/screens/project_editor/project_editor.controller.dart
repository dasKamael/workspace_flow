import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/project/service/window_capture.service.dart';
import 'package:workspace_flow/domain/project/window_snap.util.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.state.dart';

part 'project_editor.controller.g.dart';

/// Drives the project editor sheet.
///
/// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
@riverpod
class ProjectEditorController extends _$ProjectEditorController {
  /// Default size of a freshly placed window, in percent.
  static const double defaultWidth = 50;
  static const double defaultHeight = 100;

  @override
  ProjectEditorState build(int? projectId) {
    if (projectId == null) return const ProjectEditorState(isLoaded: true);

    final project = ref.watch(projectsProvider).valueOrNull?.where((project) => project.id == projectId).firstOrNull;

    if (project == null) return ProjectEditorState(projectId: projectId);

    return ProjectEditorState(projectId: project.id, name: project.name, windows: project.windows, isLoaded: true);
  }

  void setName(String name) => state = state.copyWith(name: name);

  void select(int? index) => state = state.copyWith(selectedIndex: index);

  /// Places [entry] on [screenIndex], centred on the drop position.
  void place({required AppLibraryEntry entry, required int screenIndex, required double x, required double y}) {
    final window = ProjectWindow(
      // Draft ids are negative so they never collide with persisted rows.
      id: -(state.windows.length + 1),
      name: entry.name,
      bundleId: entry.bundleId,
      url: entry.url,
      screenIndex: screenIndex,
      x: _clampPosition(x - defaultWidth / 2, defaultWidth),
      y: _clampPosition(y - defaultHeight / 2, defaultHeight),
      width: defaultWidth,
      height: defaultHeight,
    );
    state = state.copyWith(windows: [...state.windows, window], selectedIndex: state.windows.length);
  }

  /// Moves a tile to a raw target position, possibly onto a different monitor.
  ///
  /// [x] and [y] come straight from the pointer, derived from where the drag started —
  /// never from the previously written value. Feeding a snapped value back in would
  /// make the tile stick to the first magnet it touched.
  void move({
    required int index,
    required int screenIndex,
    required double x,
    required double y,
    required ProjectWindow origin,
    bool magnetsEnabled = true,
  }) {
    final moving = origin.copyWith(screenIndex: screenIndex);
    final snap = WindowSnapUtil.snapMove(
      moving: moving,
      neighbours: state.windows,
      x: x,
      y: y,
      magnetsEnabled: magnetsEnabled,
    );

    _patch(index, (window) => window.copyWith(screenIndex: screenIndex, x: snap.x, y: snap.y));
    state = state.copyWith(draggingIndex: index, guidesX: snap.guidesX, guidesY: snap.guidesY);
  }

  /// Resizes a tile by dragging one of its eight handles.
  ///
  /// [origin] is the rectangle the drag started from and the deltas are cumulative, so
  /// the result never drifts across a long drag.
  void resize({
    required int index,
    required ResizeHandle handle,
    required double deltaX,
    required double deltaY,
    required ProjectWindow origin,
    bool magnetsEnabled = true,
  }) {
    final snap = WindowSnapUtil.snapResize(
      window: origin,
      handle: handle,
      deltaX: deltaX,
      deltaY: deltaY,
      neighbours: state.windows,
      magnetsEnabled: magnetsEnabled,
    );

    _patch(index, (window) => window.copyWith(x: snap.x, y: snap.y, width: snap.width, height: snap.height));
    state = state.copyWith(draggingIndex: index, guidesX: snap.guidesX, guidesY: snap.guidesY);
  }

  /// Ends a drag or resize: the guides disappear with it.
  void endDrag() => state = state.copyWith(draggingIndex: null, guidesX: const [], guidesY: const []);

  /// Replaces the draft with the windows that are open right now.
  ///
  /// Returns false when nothing could be read — no permission, or nothing worth
  /// capturing — and leaves the draft untouched in that case. Nothing is persisted
  /// until Save, so Cancel still gets the previous layout back.
  Future<bool> captureCurrentArrangement() async {
    final captured = await ref.read(windowCaptureServiceProvider.notifier).capture();
    if (captured.isEmpty) return false;

    // The captured apps become chips too, so they can be re-added after a change of mind.
    final projects = ref.read(projectServiceProvider.notifier);
    for (final window in captured) {
      await projects.addToLibrary(AppLibraryEntry(name: window.name, bundleId: window.bundleId));
    }

    state = state.copyWith(windows: captured, selectedIndex: null);
    return true;
  }

  void remove(int index) {
    final windows = [...state.windows]..removeAt(index);
    state = state.copyWith(windows: windows, selectedIndex: null);
  }

  /// Saves the draft. An empty name becomes "Untitled project"; unnamed windows are
  /// dropped, as the design specifies.
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

  void _patch(int index, ProjectWindow Function(ProjectWindow window) patch) {
    if (index < 0 || index >= state.windows.length) return;
    final windows = [...state.windows];
    windows[index] = patch(windows[index]);
    state = state.copyWith(windows: windows);
  }

  /// Keeps a tile fully inside its monitor.
  static double _clampPosition(double value, double size) => value.clamp(0, (100 - size).clamp(0, 100));
}
