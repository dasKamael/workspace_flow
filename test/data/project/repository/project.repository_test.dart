import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

import '../../../database.test_util.dart';

void main() {
  late ProjectRepository repository;

  ProjectWindow window(String name, {int screenIndex = 0, double x = 0, double width = 50}) =>
      ProjectWindow(id: 0, name: name, screenIndex: screenIndex, x: x, y: 0, width: width, height: 100);

  setUp(() {
    repository = ProjectRepository(dao: ProjectDao(createTestDatabase()));
  });

  test('Given a project with two windows, '
      'when it is created and read back, '
      'then name and layout round-trip in the saved order', () async {
    // Given / When
    await repository.createProject(
      name: 'App-Care Sprint',
      windows: [window('VS Code', width: 62.5), window('Figma', x: 62.5, width: 37.5)],
    );
    final projects = await repository.watchProjects().first;

    // Then
    expect(projects, hasLength(1));
    expect(projects.single.name, 'App-Care Sprint');
    expect(projects.single.windows.map((w) => w.name), ['VS Code', 'Figma']);
    expect(projects.single.windows.last.x, 62.5);
    expect(projects.single.windows.last.width, 37.5);
    expect(projects.single.windowCount, 2);
  });

  test('Given a saved project, '
      'when the layout is replaced, '
      'then the old windows are gone instead of being appended', () async {
    // Given
    final id = await repository.createProject(name: 'Deep Writing', windows: [window('Ulysses'), window('Chrome')]);

    // When
    await repository.saveProject(id: id, name: 'Deep Writing', windows: [window('Spotify')]);
    final projects = await repository.watchProjects().first;

    // Then
    expect(projects.single.windows.map((w) => w.name), ['Spotify']);
  });

  test('Given a project with windows, '
      'when the project is deleted, '
      'then its windows are removed with it', () async {
    // Given
    final id = await repository.createProject(name: 'Admin & Inbox', windows: [window('Mail')]);

    // When
    await repository.deleteProject(id);

    // Then — the cascade fires, so recreating does not resurrect old rows
    expect(await repository.watchProjects().first, isEmpty);
    final newId = await repository.createProject(name: 'Admin & Inbox', windows: []);
    final projects = await repository.watchProjects().first;
    expect(projects.single.id, newId);
    expect(projects.single.windows, isEmpty);
  });

  test('Given an app that is already in the library, '
      'when it is added again, '
      'then it stays a single entry', () async {
    // Given
    const entry = AppLibraryEntry(name: 'Figma', bundleId: 'com.figma.Desktop');

    // When
    await repository.addToAppLibrary(entry);
    await repository.addToAppLibrary(entry);

    // Then
    final library = await repository.watchAppLibrary().first;
    expect(library, hasLength(1));
    expect(library.single.bundleId, 'com.figma.Desktop');
  });

  test('Given several projects created in sequence, '
      'when they are read back, '
      'then they keep their creation order', () async {
    // Given
    await withClock(Clock.fixed(DateTime(2026, 8, 28, 9, 38)), () async {
      await repository.createProject(name: 'First', windows: []);
      await repository.createProject(name: 'Second', windows: []);
      await repository.createProject(name: 'Third', windows: []);
    });

    // When
    final projects = await repository.watchProjects().first;

    // Then
    expect(projects.map((p) => p.name), ['First', 'Second', 'Third']);
    expect(projects.map((p) => p.sortOrder), [0, 1, 2]);
  });
}
