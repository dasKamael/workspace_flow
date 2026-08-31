import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';
import 'package:workspace_flow/domain/project/model/launch_progress.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/launch.service.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

void main() {
  late MockAppLauncherRepository launcher;
  late MockWindowControlRepository windowControl;

  // Two displays, the second placed to the right of the first.
  const screens = [
    ScreenInfo(index: 0, visibleX: 0, visibleY: 25, visibleWidth: 2560, visibleHeight: 1415, isMain: true),
    ScreenInfo(index: 1, visibleX: 2560, visibleY: 0, visibleWidth: 1512, visibleHeight: 945, isMain: false),
  ];

  const project = Project(
    id: 1,
    name: 'App-Care Sprint',
    windows: [
      ProjectWindow(
        id: 10,
        name: 'VS Code',
        bundleId: 'com.microsoft.VSCode',
        screenIndex: 0,
        x: 0,
        y: 0,
        width: 62.5,
        height: 100,
      ),
      ProjectWindow(
        id: 11,
        name: 'Chrome',
        bundleId: 'com.google.Chrome',
        screenIndex: 1,
        x: 0,
        y: 0,
        width: 100,
        height: 60,
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const Duration(seconds: 8));
  });

  setUp(() {
    launcher = MockAppLauncherRepository();
    windowControl = MockWindowControlRepository();
    when(() => launcher.launchApp(bundleId: any(named: 'bundleId'))).thenAnswer((_) async => 4242);
    when(
      () => launcher.launchWithDocument(
        bundleId: any(named: 'bundleId'),
        documentPath: any(named: 'documentPath'),
      ),
    ).thenAnswer((_) async => 4242);
    when(() => launcher.openUrl(any())).thenAnswer((_) async {});
    when(() => windowControl.isAccessibilityTrusted()).thenAnswer((_) async => true);
    when(
      () => windowControl.positionWindow(
        processId: any(named: 'processId'),
        x: any(named: 'x'),
        y: any(named: 'y'),
        width: any(named: 'width'),
        height: any(named: 'height'),
        timeout: any(named: 'timeout'),
      ),
    ).thenAnswer((_) async => true);
  });

  ProviderContainer makeContainer() => createContainer(
    overrides: [
      appLauncherRepositoryProvider.overrideWithValue(launcher),
      windowControlRepositoryProvider.overrideWithValue(windowControl),
      screensProvider.overrideWith((ref) async => screens),
    ],
  );

  test('Given a project with two windows on two monitors, '
      'when it is launched, '
      'then each app is started and positioned on its own screen', () async {
    // Given
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(project);

    // Then — every window reports "open"
    final progress = container.read(launchServiceProvider);
    expect(progress.stepFor(10), LaunchStep.open);
    expect(progress.stepFor(11), LaunchStep.open);
    expect(progress.hasLaunched, isTrue);
    expect(progress.isLaunching, isFalse);

    verify(() => launcher.launchApp(bundleId: 'com.microsoft.VSCode')).called(1);
    verify(() => launcher.launchApp(bundleId: 'com.google.Chrome')).called(1);

    // ... at the absolute rectangle its percentages map to on that screen
    verify(
      () => windowControl.positionWindow(
        processId: 4242,
        x: 0,
        y: 25,
        width: 1600,
        height: 1415,
        timeout: any(named: 'timeout'),
      ),
    ).called(1);
    verify(
      () => windowControl.positionWindow(
        processId: 4242,
        x: 2560,
        y: 0,
        width: 1512,
        height: 567,
        timeout: any(named: 'timeout'),
      ),
    ).called(1);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given a project launched once while only one screen is attached, '
      'when a second screen is connected and the project is launched again, '
      'then the second window lands on the newly attached screen instead of the stale, one-screen list', () async {
    // Given — `screensProvider` is keepAlive, so its first resolution must not stick
    // around forever; a plain `overrideWithValue`-style fixed list would hide that bug.
    var currentScreens = [screens[0]];
    final container = createContainer(
      overrides: [
        appLauncherRepositoryProvider.overrideWithValue(launcher),
        windowControlRepositoryProvider.overrideWithValue(windowControl),
        screensProvider.overrideWith((ref) async => currentScreens),
      ],
    );
    await container.read(launchServiceProvider.notifier).launch(project);
    container.read(launchServiceProvider.notifier).reset();

    // When — the second monitor is attached, and the project is launched again
    currentScreens = screens;
    await container.read(launchServiceProvider.notifier).launch(project);

    // Then — Chrome, saved for screen 1, is placed on the real second screen rather
    // than falling back to the main screen the way a detached display would
    verify(
      () => windowControl.positionWindow(
        processId: 4242,
        x: 2560,
        y: 0,
        width: 1512,
        height: 567,
        timeout: any(named: 'timeout'),
      ),
    ).called(1);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given accessibility permission is missing, '
      'when a project is launched, '
      'then the apps still start but nothing is positioned', () async {
    // Given
    when(() => windowControl.isAccessibilityTrusted()).thenAnswer((_) async => false);
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(project);

    // Then
    final progress = container.read(launchServiceProvider);
    expect(progress.needsAccessibilityPermission, isTrue);
    expect(progress.stepFor(10), LaunchStep.open);
    verify(() => launcher.launchApp(bundleId: any(named: 'bundleId'))).called(2);
    verifyNever(
      () => windowControl.positionWindow(
        processId: any(named: 'processId'),
        x: any(named: 'x'),
        y: any(named: 'y'),
        width: any(named: 'width'),
        height: any(named: 'height'),
        timeout: any(named: 'timeout'),
      ),
    );
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given an app that fails to start, '
      'when the project is launched, '
      'then its row reports the failure and the rest still opens', () async {
    // Given
    when(() => launcher.launchApp(bundleId: 'com.microsoft.VSCode')).thenAnswer((_) async => null);
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(project);

    // Then
    final progress = container.read(launchServiceProvider);
    expect(progress.stepFor(10), LaunchStep.failed);
    expect(progress.stepFor(11), LaunchStep.open);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given a window whose saved monitor is no longer attached, '
      'when the project is launched, '
      'then it falls back to the main screen instead of being skipped', () async {
    // Given — a layout saved on a third display
    const detached = Project(
      id: 2,
      name: 'Deep Writing',
      windows: [
        ProjectWindow(
          id: 20,
          name: 'Ulysses',
          bundleId: 'com.soulmen.ulysses',
          screenIndex: 5,
          x: 0,
          y: 0,
          width: 100,
          height: 100,
        ),
      ],
    );
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(detached);

    // Then — placed on the main screen's visible frame
    verify(
      () => windowControl.positionWindow(
        processId: 4242,
        x: 0,
        y: 25,
        width: 2560,
        height: 1415,
        timeout: any(named: 'timeout'),
      ),
    ).called(1);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given a project containing a website, '
      'when it is launched, '
      'then the url is opened and no window placement is attempted for it', () async {
    // Given
    const withSite = Project(
      id: 3,
      name: 'Admin & Inbox',
      windows: [
        ProjectWindow(
          id: 30,
          name: 'app-care.de',
          url: 'https://app-care.de',
          screenIndex: 0,
          x: 0,
          y: 0,
          width: 100,
          height: 100,
        ),
      ],
    );
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(withSite);

    // Then — a browser tab has no window of its own to place
    verify(() => launcher.openUrl('https://app-care.de')).called(1);
    verifyNever(() => launcher.launchApp(bundleId: any(named: 'bundleId')));
    expect(container.read(launchServiceProvider).stepFor(30), LaunchStep.open);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given a window naming a project folder, '
      'when it is launched, '
      'then the app opens that folder instead of starting blank', () async {
    // Given
    const withProject = Project(
      id: 4,
      name: 'Client Work',
      windows: [
        ProjectWindow(
          id: 40,
          name: 'VS Code — client-a',
          bundleId: 'com.microsoft.VSCode',
          documentPath: '/Users/dev/client-a',
          screenIndex: 0,
          x: 0,
          y: 0,
          width: 100,
          height: 100,
        ),
      ],
    );
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(withProject);

    // Then — the document-aware launch is used, not a blank one
    verify(
      () => launcher.launchWithDocument(bundleId: 'com.microsoft.VSCode', documentPath: '/Users/dev/client-a'),
    ).called(1);
    verifyNever(() => launcher.launchApp(bundleId: any(named: 'bundleId')));
    expect(container.read(launchServiceProvider).stepFor(40), LaunchStep.open);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('Given two windows for the same app with different project folders, '
      'when the project is launched, '
      'then each opens its own project rather than one window twice', () async {
    // Given
    const twoClients = Project(
      id: 5,
      name: 'Two Clients',
      windows: [
        ProjectWindow(
          id: 50,
          name: 'VS Code — client-a',
          bundleId: 'com.microsoft.VSCode',
          documentPath: '/Users/dev/client-a',
          screenIndex: 0,
          x: 0,
          y: 0,
          width: 50,
          height: 100,
        ),
        ProjectWindow(
          id: 51,
          name: 'VS Code — client-b',
          bundleId: 'com.microsoft.VSCode',
          documentPath: '/Users/dev/client-b',
          screenIndex: 1,
          x: 0,
          y: 0,
          width: 50,
          height: 100,
        ),
      ],
    );
    final container = makeContainer();

    // When
    await container.read(launchServiceProvider.notifier).launch(twoClients);

    // Then
    verify(
      () => launcher.launchWithDocument(bundleId: 'com.microsoft.VSCode', documentPath: '/Users/dev/client-a'),
    ).called(1);
    verify(
      () => launcher.launchWithDocument(bundleId: 'com.microsoft.VSCode', documentPath: '/Users/dev/client-b'),
    ).called(1);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
