import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/domain/focus/model/focus_stats.dart';
import 'package:workspace_flow/domain/focus/service/focus_session.service.dart';
import 'package:workspace_flow/domain/focus/service/focus_stats.service.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/presentation/screens/focus_running/focus_running.screen.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/projects_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/workspace.screen.dart';

import '../../../mocks/focus.mock.dart';
import '../../../riverpod.test_util.dart';
import '../../../widgettest.test_util.dart';

/// The window body is either the three columns or the running session — and whichever
/// it is has to fill the window, not shrink to its content.
void main() {
  late MockFocusSessionRepository sessions;
  late MockMenuBarRepository menuBar;
  late ProviderContainer container;

  /// Design body size: the 1240px window minus the 46px title bar.
  const surface = Size(1240, 782);
  const bodyHeight = 736.0;

  const project = Project(
    id: 1,
    name: 'App-Care Sprint',
    windows: [ProjectWindow(id: 10, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 62.5, height: 100)],
  );

  setUp(() {
    sessions = MockFocusSessionRepository();
    menuBar = MockMenuBarRepository();
    when(() => sessions.startSession(plannedMinutes: any(named: 'plannedMinutes'))).thenAnswer((_) async => 1);
    when(
      () => sessions.finishSession(
        id: any(named: 'id'),
        elapsedSeconds: any(named: 'elapsedSeconds'),
      ),
    ).thenAnswer((_) async {});
    when(() => menuBar.showCountdown(any())).thenAnswer((_) async {});
    when(menuBar.hide).thenAnswer((_) async {});
    when(() => menuBar.setSessionRunning(isRunning: any(named: 'isRunning'))).thenAnswer((_) async {});
    when(() => menuBar.toggleFocusRequests).thenAnswer((_) => const Stream<void>.empty());
    when(() => menuBar.startFocusRequests).thenAnswer((_) => const Stream<int>.empty());

    container = createContainer(
      overrides: [
        projectsProvider.overrideWith((ref) => Stream.value(const [project])),
        blockerProfilesProvider.overrideWith((ref) => Stream.value(const <BlockerProfile>[])),
        focusStatsProvider.overrideWith((ref) => Stream.value(const FocusStats())),
        focusSessionRepositoryProvider.overrideWithValue(sessions),
        menuBarRepositoryProvider.overrideWithValue(menuBar),
      ],
    );
  });

  /// Pumped with explicit frames rather than settled: a running session ticks every
  /// second and the "in focus" dot pulses forever, so nothing ever settles.
  Future<void> pumpWorkspace(WidgetTester tester) async {
    await pumpAppWidget(
      tester,
      container: container,
      surfaceSize: surface,
      settle: false,
      child: const WorkspaceScreen(),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// Ends the session so its one-second ticker does not outlive the widget tree.
  Future<void> stopSession(WidgetTester tester) async {
    await container.read(focusSessionServiceProvider.notifier).stop();
    await tester.pump();
  }

  testWidgets('Given the idle workspace, '
      'when it is shown, '
      'then the three columns fill the window below the title bar', (tester) async {
    // Given / When
    await pumpWorkspace(tester);

    // Then
    expect(tester.getSize(find.byType(ProjectsCard)).height, bodyHeight - 32);
    expect(find.byType(BlockerCard), findsOneWidget);
  });

  testWidgets('Given a started session, '
      'when the running view replaces the body, '
      'then it fills the whole window instead of shrinking to its content', (tester) async {
    // Given
    await pumpWorkspace(tester);
    expect(find.byType(FocusRunningScreen), findsNothing);

    // When
    await container.read(focusSessionServiceProvider.notifier).start();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Then — the full body, not a small box in the middle
    final size = tester.getSize(find.byType(FocusRunningScreen));
    expect(size.width, surface.width);
    expect(size.height, bodyHeight);

    await stopSession(tester);
  });

  testWidgets('Given a running session, '
      'when the window is shown, '
      'then nothing but the session is visible', (tester) async {
    // Given
    await pumpWorkspace(tester);

    // When
    await container.read(focusSessionServiceProvider.notifier).start();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Then
    expect(find.byType(ProjectsCard), findsNothing);
    expect(find.byType(BlockerCard), findsNothing);
    expect(find.text('STOP'), findsOneWidget);

    await stopSession(tester);
  });
}
