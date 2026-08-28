import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.controller.dart';

import '../../../riverpod.test_util.dart';

/// The sheet only decides *what* is in a project; *where* it goes is settled in the
/// full-size overlay, so the controller no longer carries any drag geometry.
void main() {
  late ProviderContainer container;

  ProjectEditorController controller() => container.read(projectEditorControllerProvider(null).notifier);
  ProjectWindow firstWindow() => container.read(projectEditorControllerProvider(null)).windows.first;

  setUp(() {
    container = createContainer(overrides: [projectsProvider.overrideWith((ref) => Stream.value(const <Project>[]))]);
  });

  test('Given a website typed into the editor, '
      'when it is placed, '
      'then the new window is centred on the drop point', () {
    // Given / When — a 50×100 window dropped at (50, 50)
    controller().place(
      entry: const AppLibraryEntry(name: 'app-care.de', url: 'https://app-care.de'),
      screenIndex: 0,
      x: 50,
      y: 50,
    );

    // Then
    expect(firstWindow().x, 25);
    expect(firstWindow().width, ProjectWindow.defaultWidth);
    // A full-height window cannot be centred vertically, so it clamps to the top.
    expect(firstWindow().y, 0);
  });

  test('Given a drop near the right edge, '
      'when it is placed, '
      'then the window stays fully inside the monitor', () {
    // Given / When
    controller().place(entry: const AppLibraryEntry(name: 'Chrome'), screenIndex: 0, x: 98, y: 50);

    // Then — a 50%-wide window can start at 50% at the latest
    expect(firstWindow().x, 50);
  });

  test('Given several placed windows, '
      'when they are added, '
      'then each gets a negative id so it cannot collide with a stored row', () {
    // Given / When
    controller()
      ..place(entry: const AppLibraryEntry(name: 'Figma'), screenIndex: 0, x: 25, y: 0)
      ..place(entry: const AppLibraryEntry(name: 'Slack'), screenIndex: 1, x: 75, y: 0);

    // Then
    final windows = container.read(projectEditorControllerProvider(null)).windows;
    expect(windows.map((window) => window.id), everyElement(lessThan(0)));
    expect(windows.last.screenIndex, 1);
  });
}
