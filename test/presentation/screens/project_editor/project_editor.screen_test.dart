import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.screen.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';
import '../../../widgettest.test_util.dart';

/// The editors are transparent overlay routes with no Scaffold above them, so anything
/// inside that needs a `Material` ancestor has to bring its own. These tests pump the
/// sheet in exactly that tree.
void main() {
  late ProviderContainer container;

  // A 27" main display plus a second one whose physical size macOS does not report.
  const screens = [
    ScreenInfo(
      index: 0,
      visibleX: 0,
      visibleY: 25,
      visibleWidth: 2560,
      visibleHeight: 1415,
      isMain: true,
      diagonalInches: 26.8,
    ),
    ScreenInfo(index: 1, visibleX: 2560, visibleY: 0, visibleWidth: 1512, visibleHeight: 945, isMain: false),
  ];

  setUp(() {
    container = createContainer(
      overrides: [
        projectRepositoryProvider.overrideWithValue(ProjectRepository(dao: ProjectDao(createTestDatabase()))),
        screensProvider.overrideWith((ref) async => screens),
      ],
    );
  });

  testWidgets('Given the new-project sheet, '
      'when it is opened on an overlay route, '
      'then it renders without a missing-Material error', (tester) async {
    // Given / When
    await pumpOverlayRoute(tester, container: container, child: const ProjectEditorScreen(projectId: null));

    // Then
    expect(tester.takeException(), isNull);
    expect(find.text('New project'), findsOneWidget);
    expect(find.text('Choose from Finder…'.toUpperCase()), findsOneWidget);
  });

  testWidgets('Given a project library, '
      'when the editor is opened, '
      'then the apps are listed on the right and no monitor preview is drawn', (tester) async {
    // Given / When
    await pumpOverlayRoute(tester, container: container, child: const ProjectEditorScreen(projectId: null));

    // Then — the two concerns are separated: where windows go, and which apps exist
    expect(find.text('WINDOW LAYOUT'), findsOneWidget);
    expect(find.text('ARRANGE ON SCREEN'), findsOneWidget);
    expect(find.text('USE CURRENT ARRANGEMENT'), findsOneWidget);

    // ... and the library sits under "apps & websites", not in a section of its own
    expect(find.text('APPS & WEBSITES'), findsOneWidget);
    expect(find.text('APP LIBRARY'), findsNothing);
    expect(find.text('SHOW PREVIEW'), findsNothing);
  });
}
