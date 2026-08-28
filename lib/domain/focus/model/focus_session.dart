import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_session.freezed.dart';

/// The dial's upper bound, in minutes.
const int kFocusMaxMinutes = 120;

/// The dial snaps to this step.
const int kFocusSnapMinutes = 5;

/// Shortest session the dial allows.
const int kFocusMinMinutes = 5;

/// The length the app starts on — "Deep work".
const int kFocusDefaultMinutes = 50;

/// Runtime state of the focus timer.
///
/// [minutes] `0` means open end: [elapsed] counts up and there is no end time.
/// [secondsLeft] is the countdown for a fixed-length session.
@freezed
abstract class FocusSession with _$FocusSession {
  const factory FocusSession({
    @Default(kFocusDefaultMinutes) int minutes,
    @Default(kFocusDefaultMinutes * 60) int secondsLeft,
    @Default(0) int elapsed,
    @Default(false) bool isRunning,

    /// Row id of the session currently being recorded, if any.
    int? recordId,
  }) = _FocusSession;

  const FocusSession._();

  static const int maxMinutes = kFocusMaxMinutes;
  static const int snapMinutes = kFocusSnapMinutes;
  static const int minMinutes = kFocusMinMinutes;
  static const int defaultMinutes = kFocusDefaultMinutes;

  bool get isOpenEnd => minutes == 0;

  /// Fraction of the dial that is filled, 0–1.
  double get dialFraction => isOpenEnd ? 0 : minutes / maxMinutes;

  /// Fraction of the session still to go, 0–1. Open-end sessions show a full ring.
  double get remainingFraction {
    if (isOpenEnd) return 1;
    final total = minutes * 60;
    if (total <= 0) return 0;
    return (secondsLeft / total).clamp(0.0, 1.0);
  }

  /// Seconds shown in the centre — the countdown, or the elapsed time for open end.
  int get displaySeconds => isOpenEnd ? elapsed : secondsLeft;
}
