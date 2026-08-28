import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/system/service/seed.service.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';

/// The design's projects and profiles are written into an empty database on first
/// start — and never again. This is the only place in the app where that content is a
/// literal; everything the UI shows afterwards comes from the database.
void main() {
  late AppDatabase database;
  late ProjectRepository projects;
  late BlockerProfileRepository profiles;
  late ProviderContainer container;

  setUp(() {
    database = createTestDatabase();
    projects = ProjectRepository(dao: ProjectDao(database));
    profiles = BlockerProfileRepository(dao: BlockerDao(database));
    container = createContainer(
      overrides: [
        projectRepositoryProvider.overrideWithValue(projects),
        blockerProfileRepositoryProvider.overrideWithValue(profiles),
      ],
    );
  });

  Future<void> seed() => container.read(seedServiceProvider.notifier).seedIfEmpty();

  test('Given an empty database, '
      'when the seed runs, '
      'then it writes the three projects and three profiles from the design', () async {
    // Given / When
    await seed();

    // Then
    expect((await projects.watchProjects().first).map((project) => project.name), [
      'App-Care Sprint',
      'Deep Writing',
      'Admin & Inbox',
    ]);
    expect((await profiles.watchProfiles().first).map((profile) => profile.name), ['Deep Work', 'Code', 'Admin light']);
  });

  test('Given a seeded database, '
      'when the seed runs again as it does on every start, '
      'then nothing is duplicated', () async {
    // Given
    await seed();

    // When
    await seed();
    await seed();

    // Then
    expect(await projects.countProjects(), 3);
    expect(await profiles.countProfiles(), 3);
  });

  test('Given a database the user has already changed, '
      'when the seed runs, '
      'then their data is left alone and the design content is not added', () async {
    // Given
    await projects.createProject(name: 'Mine', windows: const []);
    await profiles.createProfile(name: 'My Profile', items: const []);

    // When
    await seed();

    // Then
    expect((await projects.watchProjects().first).map((p) => p.name), ['Mine']);
    expect((await profiles.watchProfiles().first).map((p) => p.name), ['My Profile']);
  });

  test('Given the seeded layout, '
      'when a project is read back, '
      'then its windows carry the percentages from the design', () async {
    // Given
    await seed();

    // When
    final sprint = (await projects.watchProjects().first).first;

    // Then — "VS Code" takes the left 62.5% of monitor 1
    final vsCode = sprint.windows.first;
    expect(vsCode.name, 'VS Code');
    expect(vsCode.screenIndex, 0);
    expect(vsCode.width, 62.5);
    expect(vsCode.height, 100);
    // ... and Chrome sits on the second monitor
    expect(sprint.windows.firstWhere((w) => w.name == 'Chrome').screenIndex, 1);
  });
}
