import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';
import 'package:workspace_flow/domain/project/service/window_capture.service.dart';
import 'package:workspace_flow/domain/system/model/captured_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// Capturing turns absolute window frames into the same percentages the editor and the
/// launcher speak, so a saved arrangement can be restored on any resolution.
void main() {
  late MockWindowControlRepository windowControl;

  // A 2560×1440 main display below a 25pt menu bar, plus a 1512×945 laptop to its right.
  const screens = [
    ScreenInfo(index: 0, visibleX: 0, visibleY: 25, visibleWidth: 2560, visibleHeight: 1415, isMain: true),
    ScreenInfo(index: 1, visibleX: 2560, visibleY: 0, visibleWidth: 1512, visibleHeight: 945, isMain: false),
  ];

  setUp(() {
    windowControl = MockWindowControlRepository();
  });

  ProviderContainer makeContainer() => createContainer(
    overrides: [
      windowControlRepositoryProvider.overrideWithValue(windowControl),
      screensProvider.overrideWith((ref) async => screens),
    ],
  );

  Future<List<dynamic>> capture(ProviderContainer container) async {
    final service = container.read(windowCaptureServiceProvider.notifier);
    return service.toLayout(await service.listOpenWindows());
  }

  test('Given a window filling the left 62.5% of the main display, '
      'when the arrangement is captured, '
      'then it comes back as those percentages', () async {
    // Given — 1600 of 2560 points wide, starting at the top of the visible frame
    when(windowControl.captureWindows).thenAnswer(
      (_) async => const [
        CapturedWindow(name: 'VS Code', bundleId: 'com.microsoft.VSCode', x: 0, y: 25, width: 1600, height: 1415),
      ],
    );
    final container = makeContainer();

    // When
    final windows = await capture(container);

    // Then
    expect(windows.single.name, 'VS Code');
    expect(windows.single.bundleId, 'com.microsoft.VSCode');
    expect(windows.single.screenIndex, 0);
    expect(windows.single.x, 0);
    expect(windows.single.y, 0);
    expect(windows.single.width, 62.5);
    expect(windows.single.height, 100);
  });

  test('Given a window on the second display, '
      'when the arrangement is captured, '
      'then it is assigned to that screen and measured against it', () async {
    // Given — the top half of the laptop screen
    when(windowControl.captureWindows).thenAnswer(
      (_) async => const [
        CapturedWindow(name: 'Chrome', bundleId: 'com.google.Chrome', x: 2560, y: 0, width: 1512, height: 567),
      ],
    );
    final container = makeContainer();

    // When
    final windows = await capture(container);

    // Then
    expect(windows.single.screenIndex, 1);
    expect(windows.single.x, 0);
    expect(windows.single.width, 100);
    expect(windows.single.height, closeTo(60, 0.001));
  });

  test('Given a window straddling both displays, '
      'when the arrangement is captured, '
      'then it lands on the screen holding the larger part of it', () async {
    // Given — 400 points on the main display, 1000 on the laptop
    when(windowControl.captureWindows).thenAnswer(
      (_) async => const [
        CapturedWindow(name: 'Slack', bundleId: 'com.tinyspeck.slackmacgap', x: 2160, y: 100, width: 1400, height: 800),
      ],
    );
    final container = makeContainer();

    // When
    final windows = await capture(container);

    // Then
    expect(windows.single.screenIndex, 1);
  });

  test('Given accessibility permission is missing, '
      'when the arrangement is captured, '
      'then nothing comes back instead of an empty layout being invented', () async {
    // Given
    when(windowControl.captureWindows).thenThrow(Exception('accessibility_denied'));
    final container = makeContainer();

    // When
    final windows = await capture(container);

    // Then
    expect(windows, isEmpty);
  });

  test('Given several captured windows, '
      'when they become a draft, '
      'then each gets a negative id so it cannot collide with a stored row', () async {
    // Given
    when(windowControl.captureWindows).thenAnswer(
      (_) async => const [
        CapturedWindow(name: 'Mail', bundleId: 'com.apple.mail', x: 0, y: 25, width: 1280, height: 1415),
        CapturedWindow(name: 'Calendar', bundleId: 'com.apple.iCal', x: 1280, y: 25, width: 1280, height: 1415),
      ],
    );
    final container = makeContainer();

    // When
    final windows = await capture(container);

    // Then
    expect(windows.map((window) => window.id), everyElement(lessThan(0)));
    expect(windows.map((window) => window.name), ['Mail', 'Calendar']);
    expect(windows.last.x, 50);
  });
}
