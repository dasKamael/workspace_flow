import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.app.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.screen.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

/// Drives the overlay exactly as one of its N native engines does — one per screen —
/// an empty app fed its payload over the method channel. The screen-level tests pump
/// the widget inside a Scaffold, which would hide anything the real entry point gets
/// wrong.
///
/// Merging every screen's tiles into one final layout on "apply" is native Swift
/// bookkeeping (`LayoutOverlayService.swift`'s `windowsByScreen`) that a Dart widget
/// test cannot exercise — these tests cover only this engine's own side of the
/// contract: parsing its `update` payload (now scoped to one `screenIndex`), telling
/// native about local edits via `windowsChanged`, accepting a tile pushed in from
/// another screen via `windowAdded`, and firing bare `apply`/`cancel` signals.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('de.coodoo.workspace_flow/layout_overlay');

  const screen = ScreenInfo(
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

  const window = ProjectWindow(id: -1, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 62.5, height: 100);
  const otherWindow = ProjectWindow(id: -1, name: 'Figma', screenIndex: 0, x: 25, y: 0, width: 50, height: 100);

  late List<MethodCall> outgoing;

  setUp(() {
    outgoing = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      outgoing.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  /// Sends an `update` the way native does — pre-scoped to this engine's own screen.
  Future<void> sendPayload(WidgetTester tester, {List<ProjectWindow> windows = const [window]}) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(
        MethodCall('update', {
          'screens': [screen.toJson(), secondScreen.toJson()],
          'screenIndex': screen.index,
          'windows': [for (final window in windows) window.toJson()],
        }),
      ),
      (_) {},
    );
    await tester.pumpAndSettle();
  }

  /// Sends a `windowAdded` push the way native relays a "move to this screen" from a
  /// different screen's engine.
  Future<void> sendWindowAdded(WidgetTester tester, ProjectWindow addedWindow) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(MethodCall('windowAdded', addedWindow.toJson())),
      (_) {},
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(2560, 1440);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const LayoutOverlayApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Given the entry point app before any payload, '
      'when it renders, '
      'then it shows nothing and does not throw', (tester) async {
    // Given / When
    await pumpApp(tester);

    // Then
    expect(tester.takeException(), isNull);
    expect(find.byType(LayoutOverlayScreen), findsNothing);
  });

  testWidgets('Given the payload arrives over the channel, '
      'when the overlay builds, '
      'then it renders the layout without a missing-Material error', (tester) async {
    // Given
    await pumpApp(tester);

    // When
    await sendPayload(tester);

    // Then — this is the shape the real engine builds, Scaffold included
    expect(tester.takeException(), isNull);
    expect(find.byType(LayoutOverlayScreen), findsOneWidget);
    expect(find.byType(WindowTile), findsOneWidget);
    expect(find.text('1600×1415'), findsOneWidget);
  });

  testWidgets('Given the overlay is showing, '
      'when a tile is removed, '
      'then this screen\'s new tile list goes back over the channel as JSON', (tester) async {
    // Given
    await pumpApp(tester);
    await sendPayload(tester);

    // When — the × of the only tile
    final tile = tester.getRect(find.byType(WindowTile).first);
    await tester.tapAt(
      Offset(tile.right - WindowTile.cornerHandleSize - WindowTile.closeSize / 2, tile.top + WindowTile.closeSize / 2),
    );
    await tester.pumpAndSettle();

    // Then
    final call = outgoing.firstWhere((call) => call.method == 'windowsChanged');
    final arguments = call.arguments as Map;
    expect(arguments['screenIndex'], 0);
    expect(arguments['windows'], isEmpty);
  });

  testWidgets('Given the overlay is showing, '
      'when the layout is applied, '
      'then a bare apply signal goes back — native already has every screen\'s '
      'latest tiles from their own "windowsChanged" reports', (tester) async {
    // Given
    await pumpApp(tester);
    await sendPayload(tester);

    // When
    await tester.tap(find.text('SAVE LAYOUT'));
    await tester.pumpAndSettle();

    // Then
    expect(outgoing.map((call) => call.method), contains('apply'));
  });

  testWidgets('Given the overlay was already used once this session, '
      'when a second, unrelated project sends its own — different — windows, '
      'then the second payload is what actually shows, not leftovers from the first', (tester) async {
    // Given — the native window and engine are reused rather than recreated, so the
    // very first payload this test sends must not linger once a second one arrives.
    await pumpApp(tester);
    await sendPayload(tester);
    expect(find.text('VS Code'), findsOneWidget);

    // When
    await sendPayload(tester, windows: const [otherWindow]);

    // Then
    expect(find.text('Figma'), findsOneWidget);
    expect(find.text('VS Code'), findsNothing);
  });

  testWidgets('Given the overlay is showing, '
      'when it is cancelled, '
      'then a cancel goes back and no apply is sent', (tester) async {
    // Given
    await pumpApp(tester);
    await sendPayload(tester);

    // When
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    // Then
    expect(outgoing.map((call) => call.method), contains('cancel'));
    expect(outgoing.map((call) => call.method), isNot(contains('apply')));
  });

  testWidgets('Given the overlay is showing with one tile, '
      'when native pushes a tile moved in from another screen, '
      'then it appears here too, without disturbing the tile already here', (tester) async {
    // Given
    await pumpApp(tester);
    await sendPayload(tester);
    expect(find.byType(WindowTile), findsOneWidget);

    // When — the tile arrives with the screenIndex it was moved to, exactly as
    // `LayoutOverlayApp._moveToOtherScreen` on the origin screen would set it
    const moved = ProjectWindow(id: -3, name: 'Slack', screenIndex: 0, x: 10, y: 10, width: 30, height: 30);
    await sendWindowAdded(tester, moved);

    // Then
    expect(find.byType(WindowTile), findsNWidgets(2));
    expect(find.text('VS Code'), findsOneWidget);
    expect(find.text('Slack'), findsOneWidget);
  });

  testWidgets('Given a tile was already removed from this screen, '
      'when native pushes a *different* tile moved in from another screen, '
      'then only the newly arrived tile shows — the removed one does not '
      'reappear', (tester) async {
    // Given — this engine's own `_windows` field is only ever the *initial* seed
    // from `update`; nothing must ever re-seed a screen from it after a local
    // edit, or a removal like this gets silently undone by an unrelated push.
    await pumpApp(tester);
    await sendPayload(tester);
    final tile = tester.getRect(find.byType(WindowTile).first);
    await tester.tapAt(
      Offset(tile.right - WindowTile.cornerHandleSize - WindowTile.closeSize / 2, tile.top + WindowTile.closeSize / 2),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WindowTile), findsNothing);

    // When — an unrelated tile arrives from another screen's own drag
    const moved = ProjectWindow(id: -3, name: 'Slack', screenIndex: 0, x: 10, y: 10, width: 30, height: 30);
    await sendWindowAdded(tester, moved);

    // Then
    expect(find.byType(WindowTile), findsOneWidget);
    expect(find.text('Slack'), findsOneWidget);
    expect(find.text('VS Code'), findsNothing);
  });
}
