import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.screen.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

import '../../../widgettest.test_util.dart';

/// The whole point of the overlay is that a tile is exactly as large on screen as the
/// window will be, so the assertions here are about real points rather than fractions.
void main() {
  // A 2560×1440 main display below a 25pt menu bar, plus a 1512×945 laptop to its right.
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
    ScreenInfo(index: 1, visibleX: 2560, visibleY: 25, visibleWidth: 1512, visibleHeight: 945, isMain: false),
  ];

  const windows = [
    ProjectWindow(
      id: -1,
      name: 'VS Code',
      bundleId: 'com.microsoft.VSCode',
      screenIndex: 0,
      x: 0,
      y: 0,
      width: 62.5,
      height: 100,
    ),
    ProjectWindow(id: -2, name: 'Chrome', screenIndex: 1, x: 0, y: 0, width: 100, height: 60),
  ];

  /// A 1×1 transparent PNG — enough to prove the bytes reach the tile.
  final iconBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
  );

  /// Two apps offered in the overlay's row; VS Code is already in the layout.
  const library = [
    AppLibraryEntry(name: 'VS Code', bundleId: 'com.microsoft.VSCode'),
    AppLibraryEntry(name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap'),
  ];

  late List<ProjectWindow>? applied;
  late int cancels;

  setUp(() {
    applied = null;
    cancels = 0;
  });

  /// The overlay window spans the union of the visible frames, so the test surface has
  /// to be that big for the tiles to land at their real coordinates.
  Future<void> pumpOverlay(WidgetTester tester) => pumpAppWidget(
    tester,
    surfaceSize: const Size(4072, 1440),
    child: LayoutOverlayScreen(
      screens: screens,
      initialWindows: windows,
      library: library,
      icons: {'com.microsoft.VSCode': iconBytes},
      onApply: (result) => applied = result,
      onCancel: () => cancels++,
    ),
  );

  testWidgets('Given a window saved as 62.5% of a 2560pt display, '
      'when the overlay renders it, '
      'then the tile is 1600 points wide — the size the window will really be', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then
    final tile = tester.getRect(find.byType(WindowTile).first);
    expect(tile.width, closeTo(1600, 0.5));
    expect(tile.height, closeTo(1415, 0.5));
    expect(tile.left, closeTo(0, 0.5));
  });

  testWidgets('Given a window on the second display, '
      'when the overlay renders it, '
      'then it sits at that display\'s offset inside the union of all screens', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then — the laptop starts 2560 points to the right of the main display
    final tile = tester.getRect(find.byType(WindowTile).last);
    expect(tile.left, closeTo(2560, 0.5));
    expect(tile.width, closeTo(1512, 0.5));
    expect(tile.height, closeTo(567, 0.5));
  });

  testWidgets('Given a tile at full size, '
      'when its readout is drawn, '
      'then it shows real points rather than percentages', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then — 1600×1415, not 62.5×100
    expect(find.text('1600×1415'), findsOneWidget);
  });

  testWidgets('Given the overlay is open, '
      'when escape is pressed, '
      'then it reports a cancel and no layout', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    // Then
    expect(cancels, 1);
    expect(applied, isNull);
  });

  testWidgets('Given the overlay is open, '
      'when return is pressed, '
      'then it hands back the current layout', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    // Then
    expect(applied, hasLength(2));
    expect(applied!.first.width, 62.5);
    expect(cancels, 0);
  });

  testWidgets('Given the overlay is open, '
      'when the toolbar buttons are used, '
      'then they do the same as the keyboard shortcuts', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.tap(find.text('SAVE LAYOUT'));
    await tester.pump();

    // Then
    expect(applied, hasLength(2));
  });

  testWidgets('Given a tile on the darkened desktop, '
      'when it is drawn, '
      'then its fill is translucent so what it will cover stays visible', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then
    final container = tester.widget<Container>(
      find.descendant(of: find.byType(WindowTile).first, matching: find.byType(Container)).first,
    );
    final fill = (container.decoration! as BoxDecoration).color!;
    expect(fill.a, lessThan(0.5), reason: 'the desktop has to show through');
    expect(fill.a, greaterThan(0.0), reason: 'but the tile still reads as a surface');
  });

  testWidgets('Given an icon was supplied for an app, '
      'when its tile is drawn, '
      'then the icon sits in the middle of it', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then — only VS Code carries a bundle id in this fixture
    expect(find.byType(Image), findsOneWidget);

    final tile = tester.getRect(find.byType(WindowTile).first);
    final icon = tester.getRect(find.byType(Image));
    expect(icon.center.dx, closeTo(tile.center.dx, 1));
    expect(icon.center.dy, closeTo(tile.center.dy, 1));
  });

  testWidgets('Given an app already in the layout, '
      'when the row of available apps is drawn, '
      'then only the ones still missing are offered', (tester) async {
    // Given / When
    await pumpOverlay(tester);

    // Then — VS Code is placed, so it is gone from the row; Slack is still there
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'Slack'), findsOneWidget);
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'VS Code'), findsNothing);
  });

  testWidgets('Given an app in the row, '
      'when it is dragged onto a screen, '
      'then a window is placed there and the chip leaves the row', (tester) async {
    // Given
    await pumpOverlay(tester);
    expect(find.byType(WindowTile), findsNWidgets(2));

    // When — dropped in the middle of the main display
    final chip = find.widgetWithText(Draggable<AppLibraryEntry>, 'Slack');
    // Moved in steps: the drag has to start before the target ever sees the pointer.
    final gesture = await tester.startGesture(tester.getCenter(chip));
    await tester.pump(const Duration(milliseconds: 200));
    for (final point in const [Offset(1800, 1100), Offset(1500, 900), Offset(1280, 700)]) {
      await gesture.moveTo(point);
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(WindowTile), findsNWidgets(3));
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'Slack'), findsNothing);

    // ... and it is part of what gets saved
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(applied!.map((window) => window.name), contains('Slack'));
  });

  testWidgets('Given a tile in the overlay, '
      'when its close button is tapped, '
      'then the window is removed from the layout', (tester) async {
    // Given
    await pumpOverlay(tester);
    expect(find.byType(WindowTile), findsNWidgets(2));

    // When — the × of the first tile
    // The button sits just left of the top-right corner grip.
    final tile = tester.getRect(find.byType(WindowTile).first);
    await tester.tapAt(
      Offset(tile.right - WindowTile.cornerHandleSize - WindowTile.closeSize / 2, tile.top + WindowTile.closeSize / 2),
    );
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(WindowTile), findsOneWidget);

    // ... and it is gone from what gets saved
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(applied!.map((window) => window.name), isNot(contains('VS Code')));
  });
}
