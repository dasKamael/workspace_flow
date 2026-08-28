import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:mocktail/mocktail.dart';

import '../../../database.test_util.dart';
import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// The providers the UI watches are fed by the database and follow it as it changes.
void main() {
  late ProjectRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = ProjectRepository(dao: ProjectDao(createTestDatabase()));
    container = createContainer(overrides: [projectRepositoryProvider.overrideWithValue(repository)]);
  });

  /// The names the projects provider currently holds.
  List<String> names() =>
      (container.read(projectsProvider).valueOrNull ?? const <Project>[]).map((project) => project.name).toList();

  test('Given a listener on the projects provider, '
      'when projects are written to the database, '
      'then the provider emits the growing list on its own', () async {
    // Given — a live subscription, as a widget would hold
    final emitted = <List<String>>[];
    container.listen(projectsProvider, (_, next) {
      final projects = next.valueOrNull;
      if (projects != null) emitted.add(projects.map((project) => project.name).toList());
    });
    await repository.createProject(name: 'First', windows: const []);
    await waitForProvider(() => names(), (names) => names.contains('First'));

    // When
    await repository.createProject(name: 'Added Later', windows: const []);

    // Then — the stream pushes the update; nothing re-reads the database by hand
    await waitForProvider(() => names(), (names) => names.contains('Added Later'));
    expect(emitted.last, ['First', 'Added Later']);
  });

  test('Given no explicit selection, '
      'when the selected project is read, '
      'then it falls back to the first stored project', () async {
    // Given
    await repository.createProject(name: 'First', windows: const []);
    await repository.createProject(name: 'Second', windows: const []);
    container.listen(projectsProvider, (_, _) {});
    await waitForProvider(names, (names) => names.length == 2);

    // When / Then
    expect(container.read(selectedProjectProvider)?.name, 'First');
  });

  test('Given a selected project, '
      'when a different one is selected, '
      'then the derived provider follows the change', () async {
    // Given
    await repository.createProject(name: 'First', windows: const []);
    final secondId = await repository.createProject(name: 'Second', windows: const []);
    container.listen(projectsProvider, (_, _) {});
    await waitForProvider(names, (names) => names.length == 2);

    // When
    container.read(selectedProjectServiceProvider.notifier).select(secondId);

    // Then
    expect(container.read(selectedProjectProvider)?.id, secondId);
    expect(container.read(selectedProjectProvider)?.name, 'Second');
  });

  test('Given a selected project that is then deleted, '
      'when the selection is read, '
      'then it falls back instead of pointing at a missing row', () async {
    // Given
    final firstId = await repository.createProject(name: 'First', windows: const []);
    await repository.createProject(name: 'Second', windows: const []);
    container.listen(projectsProvider, (_, _) {});
    await waitForProvider(names, (names) => names.length == 2);
    container.read(selectedProjectServiceProvider.notifier).select(firstId);

    // When
    await repository.deleteProject(firstId);
    await waitForProvider(names, (names) => names.length == 1);

    // Then
    expect(container.read(selectedProjectProvider)?.name, 'Second');
  });

  group('addProjectFolder', () {
    late MockAppLauncherRepository launcher;
    late ProviderContainer withLauncher;

    setUp(() {
      launcher = MockAppLauncherRepository();
      withLauncher = createContainer(
        overrides: [
          projectRepositoryProvider.overrideWithValue(repository),
          appLauncherRepositoryProvider.overrideWithValue(launcher),
        ],
      );
    });

    test('Given a folder and an app chosen in turn, '
        'when a project folder is added, '
        'then the library gets one entry naming both', () async {
      // Given
      when(launcher.chooseFolder).thenAnswer((_) async => (name: 'client-a', path: '/Users/dev/client-a'));
      when(
        launcher.chooseApp,
      ).thenAnswer((_) async => const AppLibraryEntry(name: 'VS Code', bundleId: 'com.microsoft.VSCode'));

      // When
      final entry = await withLauncher.read(projectServiceProvider.notifier).addProjectFolder();

      // Then
      expect(entry?.name, 'VS Code — client-a');
      expect(entry?.bundleId, 'com.microsoft.VSCode');
      expect(entry?.documentPath, '/Users/dev/client-a');

      final library = await repository.watchAppLibrary().first;
      expect(library.map((e) => e.name), contains('VS Code — client-a'));
    });

    test('Given the folder picker is cancelled, '
        'when a project folder is added, '
        'then nothing is added and the app is never asked for', () async {
      // Given
      when(launcher.chooseFolder).thenAnswer((_) async => null);

      // When
      final entry = await withLauncher.read(projectServiceProvider.notifier).addProjectFolder();

      // Then
      expect(entry, isNull);
      verifyNever(launcher.chooseApp);
    });

    test('Given a folder is chosen but the app picker is cancelled, '
        'when a project folder is added, '
        'then nothing is added to the library', () async {
      // Given
      when(launcher.chooseFolder).thenAnswer((_) async => (name: 'client-a', path: '/Users/dev/client-a'));
      when(launcher.chooseApp).thenAnswer((_) async => null);

      // When
      final entry = await withLauncher.read(projectServiceProvider.notifier).addProjectFolder();

      // Then
      expect(entry, isNull);
      expect(await repository.watchAppLibrary().first, isEmpty);
    });
  });
}
