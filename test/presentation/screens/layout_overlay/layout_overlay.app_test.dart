import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.app.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.screen.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

/// Drives the overlay exactly as the second Flutter engine does: an empty app that is
/// fed its payload over the method channel. The screen-level tests pump the widget
/// inside a Scaffold, which would hide anything the real entry point gets wrong.
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

  const window = ProjectWindow(id: -1, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 62.5, height: 100);

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

  /// Sends the payload the way the native side does.
  Future<void> sendPayload(WidgetTester tester) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(
        MethodCall('update', {
          'screens': [screen.toJson()],
          'windows': [window.toJson()],
        }),
      ),
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
      'when the layout is applied, '
      'then the edited windows go back over the channel as JSON', (tester) async {
    // Given
    await pumpApp(tester);
    await sendPayload(tester);

    // When
    await tester.tap(find.text('SAVE LAYOUT'));
    await tester.pumpAndSettle();

    // Then
    expect(outgoing.map((call) => call.method), contains('apply'));
    final payload = outgoing.firstWhere((call) => call.method == 'apply').arguments as Map;
    final windows = (payload['windows']! as List).cast<Map<Object?, Object?>>();
    expect(windows, hasLength(1));
    expect(ProjectWindow.fromJson(windows.single.map((k, v) => MapEntry(k.toString(), v))), window);
  });

  testWidgets('Given the overlay is showing, '
      'when it is cancelled, '
      'then a cancel goes back and no layout is sent', (tester) async {
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
}
