import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.controller.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.state.dart';

import '../../../riverpod.test_util.dart';

void main() {
  late ProviderContainer container;

  ProjectEditorController controller() => container.read(projectEditorControllerProvider(null).notifier);
  ProjectWindow firstWindow() => container.read(projectEditorControllerProvider(null)).windows.first;

  setUp(() {
    container = createContainer(overrides: [projectsProvider.overrideWith((ref) => Stream.value(const <Project>[]))]);
  });

  group('placing', () {
    test('Given a chip dropped in the middle of a monitor, '
        'when it is placed, '
        'then the new window is centred on the drop point', () {
      // Given / When — a 50×100 window dropped at (50, 50)
      controller().place(entry: const AppLibraryEntry(name: 'Figma'), screenIndex: 0, x: 50, y: 50);

      // Then
      expect(firstWindow().x, 25);
      expect(firstWindow().width, 50);
      // A full-height window cannot be centred vertically, so it clamps to the top.
      expect(firstWindow().y, 0);
    });

    test('Given a chip dropped near the right edge, '
        'when it is placed, '
        'then the window stays fully inside the monitor', () {
      // Given / When
      controller().place(entry: const AppLibraryEntry(name: 'Chrome'), screenIndex: 0, x: 98, y: 50);

      // Then — a 50%-wide window can start at 50% at the latest
      expect(firstWindow().x, 50);
    });
  });

  /// The editor's draft state, for the transient drag fields.
  ProjectEditorState editorState() => container.read(projectEditorControllerProvider(null));

  group('moving', () {
    test('Given a window on the first monitor, '
        'when it is dragged onto the second, '
        'then it changes screen and keeps its size', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Slack'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();

      // When
      controller().move(index: 0, screenIndex: 1, x: 10, y: 0, origin: origin);

      // Then
      expect(firstWindow().screenIndex, 1);
      expect(firstWindow().x, 10);
      expect(firstWindow().width, 50);
    });

    test('Given a window dragged past the left edge, '
        'when it is moved, '
        'then its position clamps to zero', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Mail'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();

      // When
      controller().move(index: 0, screenIndex: 0, x: -30, y: -30, origin: origin);

      // Then
      expect(firstWindow().x, 0);
      expect(firstWindow().y, 0);
    });

    test('Given a drag that keeps going after touching a magnet, '
        'when each update is computed from the drag origin, '
        'then the tile follows the pointer instead of sticking', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Chrome'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();

      // When — first close enough to snap, then well past the threshold
      controller().move(index: 0, screenIndex: 0, x: 0.7, y: 0, origin: origin);
      expect(firstWindow().x, 0, reason: 'the left edge should catch the screen edge');

      controller().move(index: 0, screenIndex: 0, x: 6, y: 0, origin: origin);

      // Then — the second call still measures from the origin, so it lets go cleanly
      expect(firstWindow().x, 6);
    });

    test('Given a tile snapped to a magnet, '
        'when the drag ends, '
        'then the guides are reported while dragging and cleared afterwards', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Figma'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();

      // When
      controller().move(index: 0, screenIndex: 0, x: 0.7, y: 0, origin: origin);

      // Then
      expect(editorState().guidesX, contains(0));
      expect(editorState().draggingIndex, 0);

      // ... and the guides disappear with the drag
      controller().endDrag();
      expect(editorState().guidesX, isEmpty);
      expect(editorState().guidesY, isEmpty);
      expect(editorState().draggingIndex, isNull);
    });

    test('Given magnets are suspended, '
        'when a tile is dragged onto an edge, '
        'then it stays exactly where the pointer left it', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Mail'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();

      // When
      controller().move(index: 0, screenIndex: 0, x: 0.7, y: 0, origin: origin, magnetsEnabled: false);

      // Then
      expect(firstWindow().x, 0.7);
      expect(editorState().guidesX, isEmpty);
    });
  });

  group('resizing', () {
    test('Given the right handle, '
        'when it is dragged, '
        'then the width follows the pointer without any grid quantisation', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Terminal'), screenIndex: 0, x: 25, y: 50);
      final origin = firstWindow();

      // When
      controller().resize(index: 0, handle: ResizeHandle.right, deltaX: -6.3, deltaY: 0, origin: origin);

      // Then — the old editor snapped this to 42.5
      expect(firstWindow().width, closeTo(43.7, 0.001));
    });

    test('Given the left handle, '
        'when it is dragged outwards, '
        'then the tile grows to the left and its right edge stays put', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Notion'), screenIndex: 0, x: 50, y: 50);
      final origin = firstWindow();
      final right = origin.x + origin.width;

      // When
      controller().resize(index: 0, handle: ResizeHandle.left, deltaX: -12, deltaY: 0, origin: origin);

      // Then
      expect(firstWindow().x, closeTo(origin.x - 12, 0.001));
      expect(firstWindow().x + firstWindow().width, closeTo(right, 0.001));
    });

    test('Given a window resized below the minimum, '
        'when the handle is dragged, '
        'then it stops at 15%', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Notion'), screenIndex: 0, x: 25, y: 50);
      final origin = firstWindow();

      // When
      controller().resize(index: 0, handle: ResizeHandle.right, deltaX: -90, deltaY: 0, origin: origin);

      // Then
      expect(firstWindow().width, ProjectWindow.minSize);
    });

    test('Given a window near the right edge, '
        'when it is resized beyond the monitor, '
        'then its width stops at the edge', () {
      // Given — placed so it starts at 50%
      controller().place(entry: const AppLibraryEntry(name: 'Numbers'), screenIndex: 0, x: 98, y: 50);
      final origin = firstWindow();

      // When
      controller().resize(index: 0, handle: ResizeHandle.right, deltaX: 90, deltaY: 0, origin: origin);

      // Then
      expect(firstWindow().x + firstWindow().width, 100);
    });
  });

  group('library', () {
    test('Given two placed windows, '
        'when the placed keys are read, '
        'then those chips can be greyed out', () {
      // Given / When
      controller()
        ..place(
          entry: const AppLibraryEntry(name: 'Figma', bundleId: 'com.figma.Desktop'),
          screenIndex: 0,
          x: 25,
          y: 0,
        )
        ..place(
          entry: const AppLibraryEntry(name: 'app-care.de', url: 'https://app-care.de'),
          screenIndex: 0,
          x: 75,
          y: 0,
        );

      // Then — apps are identified by bundle id, websites by url
      expect(container.read(projectEditorControllerProvider(null)).placedKeys, {
        'com.figma.Desktop',
        'https://app-care.de',
      });
    });

    test('Given a placed window, '
        'when it is removed, '
        'then the selection is cleared as well', () {
      // Given
      controller().place(entry: const AppLibraryEntry(name: 'Spotify'), screenIndex: 0, x: 25, y: 0);

      // When
      controller().remove(0);

      // Then
      final state = container.read(projectEditorControllerProvider(null));
      expect(state.windows, isEmpty);
      expect(state.selectedIndex, isNull);
    });
  });
}
