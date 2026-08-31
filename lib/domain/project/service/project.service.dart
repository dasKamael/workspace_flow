import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

part 'project.service.g.dart';

/// All projects, kept in sync with the database.
@Riverpod(keepAlive: true)
Stream<List<Project>> projects(Ref ref) => ref.watch(projectRepositoryProvider).watchProjects();

/// The library of apps and websites offered as chips in the editor.
@Riverpod(keepAlive: true)
Stream<List<AppLibraryEntry>> appLibrary(Ref ref) => ref.watch(projectRepositoryProvider).watchAppLibrary();

/// Icons for every app currently in the library, keyed by bundle id — lets a chip show
/// the real app icon instead of just its name, so several project variants of the same
/// editor stay easy to tell apart from unrelated apps at a glance.
@Riverpod(keepAlive: true)
Future<Map<String, Uint8List>> appLibraryIcons(Ref ref) async {
  final library = await ref.watch(appLibraryProvider.future);
  final bundleIds = {for (final entry in library) ?entry.bundleId}.toList();
  if (bundleIds.isEmpty) return const {};

  try {
    return await ref.read(appLauncherRepositoryProvider).getAppIcons(bundleIds);
  } on Object {
    // The bridge is absent outside macOS and in tests; the chips just show text.
    return const {};
  }
}

/// Which project is selected in the sidebar.
///
/// Selecting a project only changes the workspace view — it never touches the blocker
/// profile or the timer, which are independent features.
@Riverpod(keepAlive: true)
class SelectedProjectService extends _$SelectedProjectService {
  @override
  int? build() => null;

  void select(int projectId) => state = projectId;
}

/// The project the workspace is showing.
///
/// Derived rather than resolved at the call site: a widget that watched the notifier
/// instead of this would never rebuild when the selection changes.
/// Falls back to the first project when nothing is selected or the selection is gone.
@Riverpod(keepAlive: true)
Project? selectedProject(Ref ref) {
  final projects = ref.watch(projectsProvider).valueOrNull ?? const <Project>[];
  if (projects.isEmpty) return null;

  final selectedId = ref.watch(selectedProjectServiceProvider);
  return projects.where((project) => project.id == selectedId).firstOrNull ?? projects.first;
}

/// Creating, saving and deleting projects.
@Riverpod(keepAlive: true)
class ProjectService extends _$ProjectService {
  @override
  void build() {}

  Future<int> create({required String name, required List<ProjectWindow> windows}) =>
      ref.read(projectRepositoryProvider).createProject(name: name, windows: windows);

  Future<void> save({required int id, required String name, required List<ProjectWindow> windows}) =>
      ref.read(projectRepositoryProvider).saveProject(id: id, name: name, windows: windows);

  Future<void> delete(int id) => ref.read(projectRepositoryProvider).deleteProject(id);

  Future<void> addToLibrary(AppLibraryEntry entry) => ref.read(projectRepositoryProvider).addToAppLibrary(entry);

  Future<void> removeFromLibrary(AppLibraryEntry entry) =>
      ref.read(projectRepositoryProvider).removeFromAppLibrary(entry);

  /// Opens the real `NSOpenPanel`, adds the chosen app to the library and returns it.
  ///
  /// Returns null when the user cancelled — or when the picker is unavailable, which is
  /// the case outside macOS and in tests.
  Future<AppLibraryEntry?> chooseFromFinder() async {
    try {
      final entry = await ref.read(appLauncherRepositoryProvider).chooseApp();
      if (entry == null) return null;
      await addToLibrary(entry);
      return entry;
    } on Object {
      return null;
    }
  }

  /// Pairs a project folder with an app and adds it to the library as its own entry —
  /// "backend" alongside plain "VS Code" — so a project opens with the right window
  /// already showing instead of a blank one.
  ///
  /// Named after the folder alone, not `"<app> — <folder>"`: the chip already sits
  /// next to the app's own icon and has little width to spare, and the folder is what
  /// tells two variants of the same app (e.g. a "backend" and a "frontend" folder
  /// opened with the same editor) apart.
  ///
  /// Asks for the folder first, then which app opens it; returns null if either step
  /// is cancelled or the pickers are unavailable.
  Future<AppLibraryEntry?> addProjectFolder() async {
    try {
      final launcher = ref.read(appLauncherRepositoryProvider);

      final folder = await launcher.chooseFolder();
      if (folder == null) return null;

      final app = await launcher.chooseApp();
      if (app == null) return null;

      final entry = AppLibraryEntry(name: folder.name, bundleId: app.bundleId, documentPath: folder.path);
      await addToLibrary(entry);
      return entry;
    } on Object {
      return null;
    }
  }
}
