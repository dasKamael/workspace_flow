import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/common/extension/duration.extension.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';

part 'focus_session.service.g.dart';

/// Owns the focus timer: length, countdown, and the session records it writes.
///
/// The tick is driven by a one-second [Timer], but the numbers are derived from
/// [clock] rather than counted up — a timer that fires late or is throttled while the
/// window is hidden must not make the session run long.
@Riverpod(keepAlive: true)
class FocusSessionService extends _$FocusSessionService {
  Timer? _timer;

  /// When the current run started, and the elapsed seconds it started from.
  DateTime? _runStartedAt;
  int _elapsedBeforeRun = 0;

  @override
  FocusSession build() {
    ref.onDispose(() => _timer?.cancel());

    final menuBar = ref.read(menuBarRepositoryProvider);
    final toggleSubscription = menuBar.toggleFocusRequests.listen((_) => _toggleFromMenuBar());
    final startSubscription = menuBar.startFocusRequests.listen(_startFromMenuBar);
    ref.onDispose(toggleSubscription.cancel);
    ref.onDispose(startSubscription.cancel);

    // Published once up front so the menu bar's toggle already reads correctly before
    // anything else has happened this run. Deferred a tick: `state` is not readable
    // until `build` itself has returned.
    Future.microtask(_publishToMenuBar);

    return const FocusSession();
  }

  /// Starts, resumes, or stops the session — whichever the menu bar's single toggle
  /// item should do given the current state.
  void _toggleFromMenuBar() {
    if (state.isRunning) {
      unawaited(stop());
    } else if (state.recordId != null) {
      resume();
    } else {
      unawaited(start());
    }
  }

  /// Starts a session of exactly [minutes] from one of the menu bar's quick-start
  /// buttons. Ignored while one is already running — the dropdown only shows these
  /// buttons while idle, but a request could still be in flight from just before a
  /// session started some other way.
  void _startFromMenuBar(int minutes) {
    if (state.isRunning) return;
    setMinutes(minutes);
    unawaited(start());
  }

  /// Sets the length from the dial. Snaps to five minutes and clamps to the dial range.
  ///
  /// Called continuously while dragging, so it returns early when nothing changed —
  /// otherwise every mouse move would restart the countdown.
  void setMinutesFromDial(double rawMinutes) {
    final snapped = (rawMinutes / FocusSession.snapMinutes).round() * FocusSession.snapMinutes;
    final clamped = snapped.clamp(FocusSession.minMinutes, FocusSession.maxMinutes);
    if (clamped == state.minutes) return;
    setMinutes(clamped);
  }

  /// Sets the length from a preset. `0` selects open end.
  void selectPreset(FocusPreset preset) => setMinutes(preset.minutes);

  /// Sets the length and resets the countdown.
  void setMinutes(int minutes) {
    final safe = minutes == 0 ? 0 : minutes.clamp(FocusSession.minMinutes, FocusSession.maxMinutes);
    state = state.copyWith(minutes: safe, secondsLeft: safe * 60, elapsed: 0);
    _publishToMenuBar();
  }

  /// Starts a session. Resets the elapsed time and records the start.
  Future<void> start() async {
    if (state.isRunning) return;

    final recordId = await ref.read(focusSessionRepositoryProvider).startSession(plannedMinutes: state.minutes);
    _elapsedBeforeRun = 0;
    _runStartedAt = clock.now();
    state = state.copyWith(isRunning: true, elapsed: 0, secondsLeft: state.minutes * 60, recordId: recordId);
    _startTicking();
  }

  /// Suspends the countdown without ending the session.
  void pause() {
    if (!state.isRunning) return;
    _elapsedBeforeRun = state.elapsed;
    _runStartedAt = null;
    _stopTicking();
    state = state.copyWith(isRunning: false);
  }

  /// Continues a paused session, keeping the elapsed time.
  void resume() {
    if (state.isRunning || state.recordId == null) return;
    _runStartedAt = clock.now();
    state = state.copyWith(isRunning: true);
    _startTicking();
  }

  /// Ends the session, records it, and resets the countdown.
  Future<void> stop() => _finish();

  /// The wall-clock time the session ends at, or null for open end.
  DateTime? endsAt() => state.isOpenEnd ? null : clock.now().add(Duration(seconds: state.secondsLeft));

  void _startTicking() {
    _stopTicking();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _publishToMenuBar();
  }

  void _stopTicking() {
    _timer?.cancel();
    _timer = null;
  }

  void _tick() {
    final startedAt = _runStartedAt;
    if (startedAt == null) return;

    final elapsed = _elapsedBeforeRun + clock.now().difference(startedAt).inSeconds;

    if (state.isOpenEnd) {
      state = state.copyWith(elapsed: elapsed);
      _publishToMenuBar();
      return;
    }

    final secondsLeft = math.max(0, state.minutes * 60 - elapsed);
    state = state.copyWith(elapsed: elapsed, secondsLeft: secondsLeft);
    _publishToMenuBar();

    if (secondsLeft == 0) unawaited(_finish());
  }

  /// Writes the session record and returns to the idle state.
  Future<void> _finish() async {
    _stopTicking();
    final recordId = state.recordId;
    final elapsed = state.elapsed;
    _runStartedAt = null;
    _elapsedBeforeRun = 0;

    state = state.copyWith(isRunning: false, elapsed: 0, secondsLeft: state.minutes * 60, recordId: null);
    _publishToMenuBar();

    if (recordId != null) {
      await ref.read(focusSessionRepositoryProvider).finishSession(id: recordId, elapsedSeconds: elapsed);
    }
  }

  /// Mirrors the countdown into the menu bar.
  ///
  /// Cosmetic, and the bridge is absent in tests and on other platforms, so a failure
  /// here must never take the timer down with it.
  void _publishToMenuBar() {
    final repository = ref.read(menuBarRepositoryProvider);
    final future = state.isRunning
        ? repository.showCountdown(Duration(seconds: state.displaySeconds).toCountdown)
        : repository.hide();
    unawaited(future.catchError((_) {}));
    unawaited(repository.setSessionRunning(isRunning: state.isRunning).catchError((_) {}));
  }
}
