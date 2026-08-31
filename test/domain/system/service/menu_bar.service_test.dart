import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/service/menu_bar.service.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// The status item's menu has no dropdown of its own to watch, so this only checks the
/// wiring: the right project gets launched, and the dropdown is fed on every change.
void main() {
  late MockAppLauncherRepository launcher;
  late MockWindowControlRepository windowControl;
  late MockMenuBarRepository menuBar;
  late StreamController<int> launchRequests;

  const project = Project(
    id: 7,
    name: 'Deep Work',
    windows: [
      ProjectWindow(
        id: 1,
        name: 'Slack',
        bundleId: 'com.tinyspeck.slackmacgap',
        screenIndex: 0,
        x: 0,
        y: 0,
        width: 50,
        height: 100,
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(const Duration(seconds: 8));
    registerFallbackValue(<Project>[]);
  });

  setUp(() {
    launcher = MockAppLauncherRepository();
    windowControl = MockWindowControlRepository();
    menuBar = MockMenuBarRepository();
    launchRequests = StreamController<int>.broadcast();

    when(() => launcher.launchApp(bundleId: any(named: 'bundleId'))).thenAnswer((_) async => 4242);
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
    when(() => menuBar.setProjects(any())).thenAnswer((_) async {});
    when(() => menuBar.launchRequests).thenAnswer((_) => launchRequests.stream);
  });

  tearDown(() => launchRequests.close());

  ProviderContainer makeContainer() {
    final container = createContainer(
      overrides: [
        appLauncherRepositoryProvider.overrideWithValue(launcher),
        windowControlRepositoryProvider.overrideWithValue(windowControl),
        menuBarRepositoryProvider.overrideWithValue(menuBar),
        screensProvider.overrideWith((ref) async => const []),
        projectsProvider.overrideWith((ref) => Stream.value(const [project])),
      ],
    );
    // Riverpod 3 pauses a stream provider's subscription while nothing actively
    // listens to it — in the real app a widget's `ref.watch` does that; here nothing
    // otherwise would, so `projectsProvider.future` below would hang forever.
    container.listen(projectsProvider, (_, _) {});
    return container;
  }

  test('Given the project list, '
      'when it changes, '
      'then the menu bar dropdown is rebuilt with it', () async {
    // Given / When
    final container = makeContainer();
    container.read(menuBarServiceProvider);
    await container.read(projectsProvider.future);

    // Then
    verify(() => menuBar.setProjects([project])).called(1);
  });

  test('Given a project chosen from the menu bar dropdown, '
      'when the request arrives, '
      'then that project is launched', () async {
    // Given
    final container = makeContainer();
    container.read(menuBarServiceProvider);
    await container.read(projectsProvider.future);

    // When
    launchRequests.add(project.id);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    verify(() => launcher.launchApp(bundleId: 'com.tinyspeck.slackmacgap')).called(1);
  });

  test('Given a request for a project that no longer exists, '
      'when it arrives, '
      'then nothing is launched', () async {
    // Given
    final container = makeContainer();
    container.read(menuBarServiceProvider);
    await container.read(projectsProvider.future);

    // When
    launchRequests.add(999);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    verifyNever(() => launcher.launchApp(bundleId: any(named: 'bundleId')));
  });
}
