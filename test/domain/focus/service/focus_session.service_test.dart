import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';
import 'package:workspace_flow/domain/focus/service/focus_session.service.dart';

import '../../../mocks/focus.mock.dart';
import '../../../riverpod.test_util.dart';

void main() {
  late MockFocusSessionRepository repository;
  late MockMenuBarRepository menuBar;

  setUp(() {
    repository = MockFocusSessionRepository();
    menuBar = MockMenuBarRepository();
    when(() => repository.startSession(plannedMinutes: any(named: 'plannedMinutes'))).thenAnswer((_) async => 1);
    when(
      () => repository.finishSession(
        id: any(named: 'id'),
        elapsedSeconds: any(named: 'elapsedSeconds'),
      ),
    ).thenAnswer((_) async {});
    when(() => menuBar.showCountdown(any())).thenAnswer((_) async {});
    when(menuBar.hide).thenAnswer((_) async {});
  });

  ProviderContainer makeContainer() => createContainer(
    overrides: [
      focusSessionRepositoryProvider.overrideWithValue(repository),
      menuBarRepositoryProvider.overrideWithValue(menuBar),
    ],
  );

  FocusSessionService serviceIn(ProviderContainer container) => container.read(focusSessionServiceProvider.notifier);
  FocusSession stateIn(ProviderContainer container) => container.read(focusSessionServiceProvider);

  /// Runs [body] with a clock tied to the fake async zone, so the service's
  /// clock-derived elapsed time advances exactly as far as the test says.
  void withFakeTime(void Function(FakeAsync async) body) {
    fakeAsync((async) {
      final start = DateTime(2026, 8, 28, 9, 38);
      withClock(Clock(() => start.add(async.elapsed)), () => body(async));
    });
  }

  group('length', () {
    test('Given the dial is dragged to 47.4 minutes, '
        'when the value is applied, '
        'then it snaps to the nearest five minutes and resets the countdown', () {
      // Given
      final container = makeContainer();

      // When
      serviceIn(container).setMinutesFromDial(47.4);

      // Then
      expect(stateIn(container).minutes, 45);
      expect(stateIn(container).secondsLeft, 45 * 60);
    });

    test('Given dial values outside the allowed range, '
        'when they are applied, '
        'then they are clamped to 5 and 120 minutes', () {
      // Given
      final container = makeContainer();

      // When / Then
      serviceIn(container).setMinutesFromDial(1);
      expect(stateIn(container).minutes, FocusSession.minMinutes);

      serviceIn(container).setMinutesFromDial(300);
      expect(stateIn(container).minutes, FocusSession.maxMinutes);
    });

    test('Given the open-end preset, '
        'when it is selected, '
        'then the session has no end time and shows a full ring', () {
      // Given
      final container = makeContainer();

      // When
      serviceIn(container).selectPreset(FocusPreset.openEnd);

      // Then
      expect(stateIn(container).isOpenEnd, isTrue);
      expect(serviceIn(container).endsAt(), isNull);
      expect(stateIn(container).remainingFraction, 1);
    });

    test('Given a 50 minute session at 09:38, '
        'when the end time is read, '
        'then it is 10:28', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(50);

        // When
        final endsAt = serviceIn(container).endsAt();

        // Then — the "ends 10:28" line from the design
        expect(endsAt, DateTime(2026, 8, 28, 10, 28));
      });
    });
  });

  group('countdown', () {
    test('Given a five minute session, '
        'when it runs for 90 seconds, '
        'then the remaining time has dropped by exactly 90 seconds', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(5);
        serviceIn(container).start();
        async.flushMicrotasks();

        // When
        async.elapse(const Duration(seconds: 90));

        // Then
        expect(stateIn(container).secondsLeft, 5 * 60 - 90);
        expect(stateIn(container).elapsed, 90);
        expect(stateIn(container).isRunning, isTrue);
      });
    });

    test('Given a running session, '
        'when the planned time has passed, '
        'then it stops, resets the countdown and is recorded', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(5);
        serviceIn(container).start();
        async.flushMicrotasks();

        // When
        async.elapse(const Duration(minutes: 5, seconds: 1));
        async.flushMicrotasks();

        // Then
        expect(stateIn(container).isRunning, isFalse);
        expect(stateIn(container).secondsLeft, 5 * 60);
        expect(stateIn(container).recordId, isNull);
        verify(() => repository.finishSession(id: 1, elapsedSeconds: 300)).called(1);
      });
    });

    test('Given an open-end session, '
        'when it runs, '
        'then the elapsed time counts up instead of down', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).selectPreset(FocusPreset.openEnd);
        serviceIn(container).start();
        async.flushMicrotasks();

        // When
        async.elapse(const Duration(minutes: 3));

        // Then
        expect(stateIn(container).elapsed, 180);
        expect(stateIn(container).displaySeconds, 180);
        expect(stateIn(container).isRunning, isTrue);
      });
    });

    test('Given a session paused after one minute, '
        'when two minutes pass while paused and it then runs for one more, '
        'then only the running time counts', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(10);
        serviceIn(container).start();
        async.flushMicrotasks();
        async.elapse(const Duration(minutes: 1));

        // When
        serviceIn(container).pause();
        async.elapse(const Duration(minutes: 2));
        serviceIn(container).resume();
        async.elapse(const Duration(minutes: 1));

        // Then
        expect(stateIn(container).elapsed, 120);
        expect(stateIn(container).secondsLeft, 10 * 60 - 120);
      });
    });

    test('Given a running session, '
        'when it is stopped early, '
        'then the countdown resets and the elapsed time is recorded', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(25);
        serviceIn(container).start();
        async.flushMicrotasks();
        async.elapse(const Duration(minutes: 4));

        // When
        serviceIn(container).stop();
        async.flushMicrotasks();

        // Then
        expect(stateIn(container).isRunning, isFalse);
        expect(stateIn(container).secondsLeft, 25 * 60);
        verify(() => repository.finishSession(id: 1, elapsedSeconds: 240)).called(1);
      });
    });

    test('Given a running session, '
        'when a tick fires late because the app was throttled, '
        'then the remaining time follows the wall clock instead of the tick count', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(30);
        serviceIn(container).start();
        async.flushMicrotasks();

        // When — the zone jumps forward by ten minutes in one go
        async.elapse(const Duration(minutes: 10));

        // Then
        expect(stateIn(container).secondsLeft, 20 * 60);
      });
    });
  });

  group('menu bar', () {
    test('Given a session that starts and is stopped, '
        'when the countdown changes, '
        'then the menu bar is updated and cleared again', () {
      withFakeTime((async) {
        // Given
        final container = makeContainer();
        serviceIn(container).setMinutes(5);

        // When
        serviceIn(container).start();
        async.flushMicrotasks();
        async.elapse(const Duration(seconds: 2));
        serviceIn(container).stop();
        async.flushMicrotasks();

        // Then
        verify(() => menuBar.showCountdown('04:58')).called(1);
        verify(menuBar.hide).called(greaterThanOrEqualTo(1));
      });
    });
  });
}
