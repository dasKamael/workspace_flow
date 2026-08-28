import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/mapper/project.entity_mapper.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

part 'project.repository.g.dart';

/// Reads and writes projects, their window layouts and the app library.
class ProjectRepository {
  ProjectRepository({required this.dao});

  final ProjectDao dao;

  static const ProjectEntityMapper _mapper = ProjectEntityMapper();
  static const AppLibraryEntryMapper _libraryMapper = AppLibraryEntryMapper();

  Stream<List<Project>> watchProjects() => dao.watchProjects().map((rows) => rows.map(_mapper.toModel).toList());

  Stream<List<AppLibraryEntry>> watchAppLibrary() =>
      dao.watchAppLibrary().map((rows) => rows.map(_libraryMapper.toModel).toList());

  Future<int> countProjects() => dao.countProjects();

  /// Creates a project and returns its id.
  Future<int> createProject({required String name, required List<ProjectWindow> windows}) async {
    final id = await dao.insertProject(
      ProjectsCompanion.insert(name: name, createdAt: clock.now(), sortOrder: Value(await dao.countProjects())),
    );
    await dao.replaceWindows(id, _companions(id, windows));
    return id;
  }

  /// Writes name and layout of an existing project.
  Future<void> saveProject({required int id, required String name, required List<ProjectWindow> windows}) async {
    await dao.updateProjectName(id, name);
    await dao.replaceWindows(id, _companions(id, windows));
  }

  Future<void> deleteProject(int id) => dao.deleteProject(id);

  Future<void> addToAppLibrary(AppLibraryEntry entry) => dao.upsertAppLibraryEntry(
    AppLibraryEntriesCompanion.insert(
      name: entry.name,
      bundleId: Value(entry.bundleId),
      path: Value(entry.path),
      url: Value(entry.url),
    ),
  );

  List<ProjectWindowsCompanion> _companions(int projectId, List<ProjectWindow> windows) => [
    for (final (index, window) in windows.indexed)
      ProjectWindowsCompanion.insert(
        projectId: projectId,
        name: window.name,
        bundleId: Value(window.bundleId),
        url: Value(window.url),
        screenIndex: Value(window.screenIndex),
        x: window.x,
        y: window.y,
        width: window.width,
        height: window.height,
        sortOrder: Value(index),
      ),
  ];
}

@Riverpod(keepAlive: true)
ProjectRepository projectRepository(Ref ref) => ProjectRepository(dao: ProjectDao(ref.watch(appDatabaseProvider)));
