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

/// One [LayoutOverlayScreen] instance is one physical screen's own native window and
/// engine now (see `LayoutOverlayService.swift` — a single Flutter view or engine
/// can't serve more than one display here), so these tests pump exactly one screen at
/// a time, at that screen's own size — never a union of several — and it owns its
/// `windows` list itself again, the way a single-screen overlay always did.
void main() {
  // A 2560×1440 main display below a 25pt menu bar, plus a 1512×945 laptop to its
  // right — deliberately NOT top-aligned with the main display's own visible area, so
  // a test that accidentally reintroduced union-relative math would show it.
  const mainScreen = ScreenInfo(
    index: 0,
    visibleX: 0,
    visibleY: 25,
    visibleWidth: 2560,
    visibleHeight: 1415,
    isMain: true,
    diagonalInches: 26.8,
  );
  const secondScreen = ScreenInfo(
    index: 1,
    visibleX: 2560,
    visibleY: 0,
    visibleWidth: 1512,
    visibleHeight: 945,
    isMain: false,
  );
  // A third display, directly right of the second — needed to reproduce a drag
  // that jumps straight from one non-origin screen's territory to another's,
  // never landing on a frame in between.
  const thirdScreen = ScreenInfo(
    index: 2,
    visibleX: 4072,
    visibleY: 0,
    visibleWidth: 1512,
    visibleHeight: 945,
    isMain: false,
  );
  const screens = [mainScreen, secondScreen];

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

  late List<ProjectWindow> lastChanged;
  late (ProjectWindow window, int targetScreenIndex)? movedToOtherScreen;
  late (ProjectWindow window, int targetScreenIndex)? lastPreview;
  late int hiddenPreviewTarget;
  late List<int> hiddenPreviewTargets;
  late int applies;
  late int cancels;

  setUp(() {
    lastChanged = windows;
    movedToOtherScreen = null;
    lastPreview = null;
    hiddenPreviewTarget = -1;
    hiddenPreviewTargets = [];
    applies = 0;
    cancels = 0;
  });

  Future<void> pumpOverlay(
    WidgetTester tester, {
    ScreenInfo screen = mainScreen,
    List<ScreenInfo> allScreens = screens,
    List<ProjectWindow> initialWindows = windows,
    List<ProjectWindow> allWindows = windows,
    List<AppLibraryEntry> libraryEntries = library,
    Map<String, Uint8List> icons = const {},
    ProjectWindow? previewWindow,
    // Bigger than this screen's own size only for tests that need to synthesize a
    // pointer position beyond its edge (a real cross-screen drag): the test binding
    // — unlike the real AppKit window it stands in for, which keeps routing a
    // captured drag's move events regardless of where the cursor physically is —
    // only dispatches a `PointerMoveEvent` within the surface it was given.
    Size? surfaceSize,
  }) => pumpAppWidget(
    tester,
    surfaceSize: surfaceSize ?? Size(screen.visibleWidth, screen.visibleHeight),
    child: LayoutOverlayScreen(
      screen: screen,
      allScreens: allScreens,
      windows: initialWindows,
      allWindows: allWindows,
      library: libraryEntries,
      icons: icons,
      previewWindow: previewWindow,
      onWindowsChanged: (updated) => lastChanged = updated,
      onMoveToOtherScreen: (window, targetScreenIndex) => movedToOtherScreen = (window, targetScreenIndex),
      onDragPreview: (window, targetScreenIndex) => lastPreview = (window, targetScreenIndex),
      onHideDragPreview: (targetScreenIndex) {
        hiddenPreviewTarget = targetScreenIndex;
        hiddenPreviewTargets.add(targetScreenIndex);
      },
      onApply: () => applies++,
      onCancel: () => cancels++,
    ),
  );

  // A pan recognizer's `onPanStart` consumes the *first* `moveTo` entirely just to
  // accept the gesture past slop — its own target becomes the new `pointerStart`,
  // not the original touch-down point — so only travel *after* this nudge actually
  // reaches `reportMove`. A bigger `surfaceSize` is needed too: unlike the real
  // AppKit window this stands in for, which keeps routing a captured drag's moves
  // regardless of where the cursor physically is, the test binding only dispatches
  // a `PointerMoveEvent` within the surface it was given.
  Future<TestGesture> startCrossScreenDrag(WidgetTester tester, Rect tile) async {
    final gesture = await tester.startGesture(tile.center);
    await tester.pump(const Duration(milliseconds: 50));
    // Comfortably past the pan recognizer's own slop threshold: a move that stays
    // under it never triggers `onPanStart` at all, and the very next move would
    // then be the one consumed to accept the gesture instead of reporting an update.
    await gesture.moveTo(tile.center + const Offset(60, 60));
    await tester.pump();
    return gesture;
  }

  testWidgets('Given a window saved as 62.5% of a 2560pt display, '
      'when its own screen\'s overlay renders it, '
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
      'when that display\'s own overlay window renders it, '
      'then it sits at that window\'s own local origin — not offset by the first '
      'display\'s size the way a single shared union window used to place it', (tester) async {
    // Given
    const onSecondScreen = ProjectWindow(id: -2, name: 'Chrome', screenIndex: 1, x: 0, y: 0, width: 100, height: 60);

    // When — this screen's own instance only ever sees its own tiles; the first
    // display not being top-aligned with it (see `mainScreen`/`secondScreen` above)
    // would show up as a wrong offset if the old union-relative math leaked back in.
    await pumpOverlay(tester, screen: secondScreen, initialWindows: const [onSecondScreen]);

    // Then
    final tile = tester.getRect(find.byType(WindowTile).first);
    expect(tile.left, closeTo(0, 0.5));
    expect(tile.top, closeTo(0, 0.5));
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
      'then it reports a cancel', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    // Then
    expect(cancels, 1);
    expect(applies, 0);
  });

  testWidgets('Given the overlay is open, '
      'when return is pressed, '
      'then it reports an apply', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    // Then
    expect(applies, 1);
    expect(cancels, 0);
  });

  testWidgets('Given the overlay is open on the main screen, '
      'when the toolbar buttons are used, '
      'then they do the same as the keyboard shortcuts', (tester) async {
    // Given
    await pumpOverlay(tester);

    // When
    await tester.tap(find.text('SAVE LAYOUT'));
    await tester.pump();

    // Then
    expect(applies, 1);
  });

  testWidgets('Given the overlay is open on a non-main screen, '
      'when it is drawn, '
      'then it has its own toolbar too — an app can only ever be dropped onto the '
      'screen it\'s dragged within, so every screen needs one to place straight '
      'onto it', (tester) async {
    // Given / When
    await pumpOverlay(tester, screen: secondScreen, initialWindows: const []);

    // Then
    expect(find.text('SAVE LAYOUT'), findsOneWidget);
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
      'then the icon sits horizontally centred, above the name label under it', (tester) async {
    // Given / When
    await pumpOverlay(tester, icons: {'com.microsoft.VSCode': iconBytes});

    // Then — only VS Code carries a bundle id in this fixture
    expect(find.byType(Image), findsOneWidget);

    final tile = tester.getRect(find.byType(WindowTile).first);
    final icon = tester.getRect(find.byType(Image));
    final name = tester.getRect(find.text('VS Code'));
    expect(icon.center.dx, closeTo(tile.center.dx, 1));
    expect(icon.bottom, lessThanOrEqualTo(name.top));
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

  testWidgets('Given an app already placed on a different screen, '
      'when this screen\'s row of available apps is drawn, '
      'then it is excluded here too — not just on the screen it was actually '
      'placed on', (tester) async {
    // Given — Slack lives only on the second screen, known here only via
    // `allWindows`, the way native's `allWindowsChanged` broadcast reports it
    const onSecondScreen = ProjectWindow(
      id: -9,
      name: 'Slack',
      bundleId: 'com.tinyspeck.slackmacgap',
      screenIndex: 1,
      x: 0,
      y: 0,
      width: 30,
      height: 30,
    );

    // When
    await pumpOverlay(tester, allWindows: [...windows, onSecondScreen]);

    // Then — this screen still only *renders* its own tile (VS Code) ...
    expect(find.byType(WindowTile), findsOneWidget);
    // ... but Slack is gone from the row anyway
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'Slack'), findsNothing);
  });

  testWidgets('Given a tile dragged past this screen\'s edge, '
      'when the drop lands on the physical area another attached screen occupies, '
      'then it moves there instead of being removed', (tester) async {
    // Given
    await pumpOverlay(tester, surfaceSize: const Size(4072, 1415));
    final tile = tester.getRect(find.byType(WindowTile).first);

    // When — dragged from the tile out past the main display's right edge, landing
    // on the physical area `secondScreen` occupies (shared x 2560..4072). Stepped,
    // not a single jump: the commit reuses the *live preview*'s last computed
    // placement (see `reportDroppedOutside`), which needs at least one real
    // `onPanUpdate` to have actually fired — a single jump gets consumed entirely
    // by `onPanStart` accepting the gesture, same reason the live-preview tests
    // above step too.
    final gesture = await startCrossScreenDrag(tester, tile);
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Then — removed from this screen ...
    expect(find.byType(WindowTile), findsNothing);
    expect(lastChanged, isEmpty);

    // ... and handed to the screen the drop actually landed on, not just discarded
    expect(movedToOtherScreen?.$1.name, 'VS Code');
    expect(movedToOtherScreen?.$2, 1);
  });

  testWidgets('Given a live preview was already showing where a tile would land, '
      'when the drag actually ends there, '
      'then it lands at exactly that same placement — not recomputed centred under '
      'the cursor at the instant of release, which would visibly jump it away from '
      'wherever the preview just showed it', (tester) async {
    // Given — grabbed off-centre on purpose: a "recompute centred under the
    // cursor" regression would then visibly disagree with the live preview,
    // instead of coincidentally landing in the same place either way.
    await pumpOverlay(tester, surfaceSize: const Size(4072, 1415));
    final tile = tester.getRect(find.byType(WindowTile).first);
    final grabPoint = tile.topLeft + const Offset(40, 40);

    final gesture = await tester.startGesture(grabPoint);
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(grabPoint + const Offset(60, 60)); // clear slop
    await tester.pump();
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();
    final previewedBeforeDrop = lastPreview!.$1;

    // When
    await gesture.up();
    await tester.pumpAndSettle();

    // Then — the exact same x/y/width/height the live preview already showed
    final landed = movedToOtherScreen!.$1;
    expect(landed.x, closeTo(previewedBeforeDrop.x, 0.01));
    expect(landed.y, closeTo(previewedBeforeDrop.y, 0.01));
    expect(landed.width, closeTo(previewedBeforeDrop.width, 0.01));
    expect(landed.height, closeTo(previewedBeforeDrop.height, 0.01));
  });

  testWidgets('Given a tile dragged far outside every attached screen, '
      'when the drop lands somewhere no screen occupies, '
      'then it is removed — the same as before cross-screen dropping existed', (tester) async {
    // Given
    await pumpOverlay(tester);
    final tile = tester.getRect(find.byType(WindowTile).first);

    // When
    final gesture = await tester.startGesture(tile.center);
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(const Offset(-500, -500));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(WindowTile), findsNothing);
    expect(movedToOtherScreen, isNull);
  });

  testWidgets('Given a tile dragged past this screen\'s edge, '
      'when it is hovering over the physical area another screen occupies, '
      'then a live preview is pushed there — before the drag has even ended', (tester) async {
    // Given
    await pumpOverlay(tester, surfaceSize: const Size(4072, 1415));
    final tile = tester.getRect(find.byType(WindowTile).first);
    final gesture = await startCrossScreenDrag(tester, tile);

    // When — onto the physical area `secondScreen` occupies (shared x 2560..4072)
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();

    // Then — nothing has actually moved yet ...
    expect(find.byType(WindowTile), findsOneWidget);
    expect(movedToOtherScreen, isNull);
    // ... but the other screen already has a live look at where it would land
    expect(lastPreview?.$1.name, 'VS Code');
    expect(lastPreview?.$2, 1);
    // ... and the real tile stops showing here — `WindowSnapUtil` clamps it stuck
    // at this screen's own edge otherwise, which would look like the tile never
    // actually left even though another screen is already showing it arrived
    final opacity = tester.widget<Opacity>(
      find.ancestor(of: find.byType(WindowTile), matching: find.byType(Opacity)).first,
    );
    expect(opacity.opacity, 0);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('Given the real tile is hidden while previewing on another screen, '
      'when the drag moves back over this screen without dropping there, '
      'then it becomes visible here again', (tester) async {
    // Given
    await pumpOverlay(tester, surfaceSize: const Size(4072, 1415));
    final tile = tester.getRect(find.byType(WindowTile).first);
    final gesture = await startCrossScreenDrag(tester, tile);
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();
    expect(
      tester.widget<Opacity>(find.ancestor(of: find.byType(WindowTile), matching: find.byType(Opacity)).first).opacity,
      0,
    );

    // When
    await gesture.moveTo(tile.center);
    await tester.pump();

    // Then
    expect(
      tester.widget<Opacity>(find.ancestor(of: find.byType(WindowTile), matching: find.byType(Opacity)).first).opacity,
      1,
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('Given a live preview is showing on another screen, '
      'when the drag moves back over this screen without dropping there, '
      'then the preview is told to hide', (tester) async {
    // Given
    await pumpOverlay(tester, surfaceSize: const Size(4072, 1415));
    final tile = tester.getRect(find.byType(WindowTile).first);
    final gesture = await startCrossScreenDrag(tester, tile);
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();
    expect(lastPreview?.$2, 1);

    // When — back over this screen's own bounds
    await gesture.moveTo(tile.center);
    await tester.pump();

    // Then
    expect(hiddenPreviewTarget, 1);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('Given a live preview is showing on one other screen, '
      'when the drag jumps straight onto a *different* other screen\'s territory — '
      'never landing on a frame in between — '
      'then the first screen\'s stale preview is explicitly hidden, not just left '
      'behind while a new one shows up on the second', (tester) async {
    // Given — a third display exists, so there are two different non-origin
    // screens a fast drag could land on with nothing in between
    await pumpOverlay(
      tester,
      allScreens: const [mainScreen, secondScreen, thirdScreen],
      surfaceSize: const Size(5700, 1415),
    );
    final tile = tester.getRect(find.byType(WindowTile).first);
    final gesture = await startCrossScreenDrag(tester, tile);

    // When — first onto the second screen's territory (shared x 2560..4072) ...
    await gesture.moveTo(const Offset(2700, 100));
    await tester.pump();
    expect(lastPreview?.$2, 1);

    // ... then straight onto the third's (shared x 4072..5584), in one jump
    await gesture.moveTo(const Offset(4200, 100));
    await tester.pump();

    // Then — the second screen's now-stale ghost was told to hide ...
    expect(hiddenPreviewTargets, contains(1));
    // ... and the third screen has the live preview now
    expect(lastPreview?.$2, 2);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('Given another screen\'s drag is hovering over this one, '
      'when this screen is drawn with that preview, '
      'then a faded, non-interactive ghost of it appears here', (tester) async {
    // Given / When
    const preview = ProjectWindow(id: -5, name: 'Figma', screenIndex: 0, x: 10, y: 10, width: 20, height: 20);
    await pumpOverlay(tester, initialWindows: const [], previewWindow: preview);

    // Then
    expect(find.text('Figma'), findsOneWidget);
    // ... wrapped so it never answers pointer events (`IgnorePointer`) — tapping
    // where it sits must not crash or select it as if it were a real tile
    await tester.tap(find.text('Figma'), warnIfMissed: false);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(lastChanged, windows);
  });

  testWidgets('Given an app in the row, '
      'when it is dragged onto this screen, '
      'then a window is placed there, the chip leaves the row, '
      'and native is told about this screen\'s new tile list', (tester) async {
    // Given
    await pumpOverlay(tester);
    expect(find.byType(WindowTile), findsOneWidget);

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
    expect(find.byType(WindowTile), findsNWidgets(2));
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'Slack'), findsNothing);
    expect(lastChanged.map((window) => window.name), containsAll(['VS Code', 'Slack']));
  });

  testWidgets('Given a tile in the overlay, '
      'when its close button is tapped, '
      'then the window is removed and native is told about this screen\'s new tile list', (tester) async {
    // Given
    await pumpOverlay(tester);
    expect(find.byType(WindowTile), findsOneWidget);

    // When — the × of the first tile
    // The button sits just left of the top-right corner grip.
    final tile = tester.getRect(find.byType(WindowTile).first);
    await tester.tapAt(
      Offset(tile.right - WindowTile.cornerHandleSize - WindowTile.closeSize / 2, tile.top + WindowTile.closeSize / 2),
    );
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(WindowTile), findsNothing);
    expect(lastChanged, isEmpty);
  });

  testWidgets('Given two library entries for the same app with different project folders, '
      'when only one is placed, '
      'then the other stays available instead of both hiding together', (tester) async {
    // Given — a developer with two clients open in the same editor
    const clientA = ProjectWindow(
      id: -1,
      name: 'VS Code — client-a',
      bundleId: 'com.microsoft.VSCode',
      documentPath: '/Users/dev/client-a',
      screenIndex: 0,
      x: 0,
      y: 0,
      width: 50,
      height: 100,
    );
    const clientB = AppLibraryEntry(
      name: 'VS Code — client-b',
      bundleId: 'com.microsoft.VSCode',
      documentPath: '/Users/dev/client-b',
    );

    await pumpOverlay(
      tester,
      initialWindows: const [clientA],
      libraryEntries: const [
        AppLibraryEntry(
          name: 'VS Code — client-a',
          bundleId: 'com.microsoft.VSCode',
          documentPath: '/Users/dev/client-a',
        ),
        clientB,
      ],
    );

    // Then — client-a is already placed and hidden, but client-b is still offered
    // even though it shares a bundle id with the placed window
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'VS Code — client-a'), findsNothing);
    expect(find.widgetWithText(Draggable<AppLibraryEntry>, 'VS Code — client-b'), findsOneWidget);
  });
}
