import 'package:drift/drift.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/project/data_source/entity/project.tables.dart';

part 'project.dao.g.dart';

/// Database access for projects, their windows and the app library.
@DriftAccessor(tables: [Projects, ProjectWindows, AppLibraryEntries])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(super.db);

  /// All projects with their windows, ordered as they appear in the sidebar.
  ///
  /// Emits again whenever a project or any of its windows changes.
  Stream<List<({ProjectEntity project, List<ProjectWindowEntity> windows})>> watchProjects() {
    final query = select(projects)
      ..orderBy([(p) => OrderingTerm(expression: p.sortOrder), (p) => OrderingTerm(expression: p.id)]);

    return query.watch().asyncMap((rows) async {
      final windowsByProject = await _windowsByProject(rows.map((row) => row.id).toList());
      return rows.map((row) => (project: row, windows: windowsByProject[row.id] ?? const [])).toList();
    });
  }

  Future<Map<int, List<ProjectWindowEntity>>> _windowsByProject(List<int> projectIds) async {
    if (projectIds.isEmpty) return {};

    final query = select(projectWindows)
      ..where((w) => w.projectId.isIn(projectIds))
      ..orderBy([(w) => OrderingTerm(expression: w.sortOrder), (w) => OrderingTerm(expression: w.id)]);

    final rows = await query.get();
    final grouped = <int, List<ProjectWindowEntity>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.projectId, () => []).add(row);
    }
    return grouped;
  }

  Future<int> insertProject(ProjectsCompanion project) => into(projects).insert(project);

  Future<void> updateProjectName(int id, String name) =>
      (update(projects)..where((p) => p.id.equals(id))).write(ProjectsCompanion(name: Value(name)));

  Future<void> deleteProject(int id) => (delete(projects)..where((p) => p.id.equals(id))).go();

  Future<int> countProjects() async {
    final count = projects.id.count();
    final row = await (selectOnly(projects)..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  /// Replaces the window layout of [projectId] in one transaction.
  ///
  /// The editor works on a draft and saves it wholesale, so replacing beats diffing.
  Future<void> replaceWindows(int projectId, List<ProjectWindowsCompanion> windows) => transaction(() async {
    await (delete(projectWindows)..where((w) => w.projectId.equals(projectId))).go();
    await batch((batch) => batch.insertAll(projectWindows, windows));
  });

  Stream<List<AppLibraryEntity>> watchAppLibrary() {
    final query = select(appLibraryEntries)..orderBy([(e) => OrderingTerm(expression: e.name)]);
    return query.watch();
  }

  /// Adds an entry unless one with the same name already exists.
  Future<void> upsertAppLibraryEntry(AppLibraryEntriesCompanion entry) =>
      into(appLibraryEntries).insert(entry, mode: InsertMode.insertOrIgnore);

  /// Removes an entry by name — the table's unique key, so it also identifies the row.
  ///
  /// Windows already placed in a saved project keep their own copy of the app's fields
  /// and are unaffected: only future drags of this chip stop being possible.
  Future<void> deleteAppLibraryEntry(String name) =>
      (delete(appLibraryEntries)..where((e) => e.name.equals(name))).go();
}
