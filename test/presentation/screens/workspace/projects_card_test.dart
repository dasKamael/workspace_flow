import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/projects_card.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';
import '../../../widgettest.test_util.dart';

/// The projects list is served from the database, not from constants: it shows whatever
/// is stored, follows it when it changes, and shows nothing when the database is empty.
///
/// Database calls go through [WidgetTester.runAsync] — sqlite runs on a background
/// isolate and would deadlock against the test binding's fake clock otherwise.
void main() {
  late ProjectRepository repository;
  late ProviderContainer container;

  ProjectWindow window(String name) =>
      ProjectWindow(id: 0, name: name, screenIndex: 0, x: 0, y: 0, width: 50, height: 100);

  setUp(() {
    repository = ProjectRepository(dao: ProjectDao(createTestDatabase()));
    container = createContainer(overrides: [projectRepositoryProvider.overrideWithValue(repository)]);
  });

  Future<void> pumpCard(WidgetTester tester) => pumpOverlayRoute(
    tester,
    container: container,
    child: const SizedBox(width: 320, height: 640, child: ProjectsCard()),
  );

  testWidgets('Given rows that exist only in the database, '
      'when the projects card is shown, '
      'then it lists exactly those names with their stored window counts', (tester) async {
    // Given — names that appear nowhere in the source
    await tester.runAsync(() async {
      await repository.createProject(name: 'Renamed In Sqlite', windows: [window('VS Code')]);
      await repository.createProject(name: 'Second From Db', windows: [window('Mail'), window('Calendar')]);
    });

    // When
    await pumpCard(tester);

    // Then
    expect(find.text('Renamed In Sqlite'), findsOneWidget);
    expect(find.text('Second From Db'), findsOneWidget);
    expect(find.text('1 app · saved layout'), findsOneWidget);
    expect(find.text('2 apps · saved layout'), findsOneWidget);
  });

  testWidgets('Given an empty database, '
      'when the projects card is shown, '
      'then it lists nothing — the design copy is not a built-in fallback', (tester) async {
    // Given / When
    await pumpCard(tester);

    // Then
    expect(find.text('App-Care Sprint'), findsNothing);
    expect(find.text('Deep Writing'), findsNothing);
  });

  testWidgets('Given two stored projects, '
      'when the second one is clicked, '
      'then it becomes the selected project and the highlight moves with it', (tester) async {
    // Given
    late final int secondId;
    await tester.runAsync(() async {
      await repository.createProject(name: 'First', windows: const []);
      secondId = await repository.createProject(name: 'Second', windows: const []);
    });
    await pumpCard(tester);

    // The first project is selected by default
    expect(container.read(selectedProjectProvider)?.name, 'First');

    // When
    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();

    // Then
    expect(container.read(selectedProjectProvider)?.id, secondId);

    // ... and exactly one tile is tinted while the other stays white.
    // Filtered by the tile radius so the surrounding card is not counted.
    final tiles = tester
        .widgetList<AnimatedContainer>(
          find.descendant(of: find.byType(ProjectsCard), matching: find.byType(AnimatedContainer)),
        )
        .map((animated) => animated.decoration)
        .whereType<BoxDecoration>()
        .where((decoration) => decoration.borderRadius == UiRadius.allXl)
        .toList();

    expect(tiles, hasLength(2));
    expect(tiles.where((tile) => tile.color == UiColor.bgAccent), hasLength(1));
    expect(tiles.where((tile) => tile.color == UiColor.white), hasLength(1));
  });
}
