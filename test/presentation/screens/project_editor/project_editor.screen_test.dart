import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/project/data_source/project.dao.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_chip.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.controller.dart';
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

  late ProjectRepository repository;

  ProjectWindow window(String name, {double x = 0}) =>
      ProjectWindow(id: 0, name: name, screenIndex: 0, x: x, y: 0, width: 50, height: 100);

  setUp(() {
    repository = ProjectRepository(dao: ProjectDao(createTestDatabase()));
    container = createContainer(
      overrides: [
        projectRepositoryProvider.overrideWithValue(repository),
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

  testWidgets('Given an entry in the library, '
      'when its × is tapped, '
      'then it disappears from the library', (tester) async {
    // Given — real sqlite I/O runs on a background isolate and would deadlock against
    // the test binding's fake clock if awaited directly in the test body.
    await tester.runAsync(
      () => repository.addToAppLibrary(const AppLibraryEntry(name: 'Figma', bundleId: 'com.figma.Desktop')),
    );
    await pumpOverlayRoute(tester, container: container, child: const ProjectEditorScreen(projectId: null));
    expect(find.text('Figma'), findsOneWidget);

    // When
    await tester.tap(find.descendant(of: find.widgetWithText(UiChip, 'Figma'), matching: find.byType(UiSvgIcon)));
    await tester.pumpAndSettle();

    // Then — gone from the on-screen library and from the database behind it
    expect(find.text('Figma'), findsNothing);
    expect(await tester.runAsync(() => repository.watchAppLibrary().first), isEmpty);
  });

  testWidgets('Given a project whose window uses an app no longer in the library, '
      'when the editor is opened, '
      'then that app still shows up', (tester) async {
    // Given — the exact shape of the old seed data: a window with no bundle id, whose
    // matching library entry has since been removed, or was never added in the first
    // place by an older seed
    final projectId = await tester.runAsync(
      () => repository.createProject(name: 'Deka', windows: [window('Mail'), window('Calendar', x: 50)]),
    );

    // When
    await pumpOverlayRoute(
      tester,
      container: container,
      child: ProjectEditorScreen(projectId: projectId),
    );

    // Then — still visible, because the project's own window still uses it
    expect(find.text('Mail'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
  });

  testWidgets('Given a project window whose app was never added to the library, '
      'when its × is tapped, '
      'then the window is dropped from the draft — the only thing that × can mean '
      'when nothing backs it in the library', (tester) async {
    // Given
    final projectId = await tester.runAsync(
      () => repository.createProject(name: 'Deka', windows: [window('Mail'), window('Calendar', x: 50)]),
    );
    await pumpOverlayRoute(
      tester,
      container: container,
      child: ProjectEditorScreen(projectId: projectId),
    );

    // When
    await tester.tap(find.descendant(of: find.widgetWithText(UiChip, 'Mail'), matching: find.byType(UiSvgIcon)));
    await tester.pumpAndSettle();

    // Then — gone from the chip list, and gone from the draft's own windows
    expect(find.text('Mail'), findsNothing);
    expect(find.text('Calendar'), findsOneWidget);
    final windows = container.read(projectEditorControllerProvider(projectId)).windows;
    expect(windows.map((w) => w.name), ['Calendar']);
  });

  testWidgets('Given an app that is both in the library and used by the project, '
      'when the editor is opened, '
      'then it appears once, still removable', (tester) async {
    // Given
    final projectId = await tester.runAsync(() async {
      await repository.addToAppLibrary(const AppLibraryEntry(name: 'Figma', bundleId: 'com.figma.Desktop'));
      return repository.createProject(
        name: 'Design',
        windows: [window('Figma').copyWith(bundleId: 'com.figma.Desktop')],
      );
    });

    // When
    await pumpOverlayRoute(
      tester,
      container: container,
      child: ProjectEditorScreen(projectId: projectId),
    );

    // Then — one chip, not two, and it is still removable since a library row exists
    expect(find.text('Figma'), findsOneWidget);
    expect(find.descendant(of: find.widgetWithText(UiChip, 'Figma'), matching: find.byType(UiSvgIcon)), findsOneWidget);
  });
}
