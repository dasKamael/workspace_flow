/// Formatting helpers for the countdown.
extension DurationExtension on Duration {
  /// `MM:SS`, with minutes unbounded — a 90 minute session reads `90:00`.
  ///
  /// Matches the prototype's `fmt()`; the design pairs it with tabular numerals so the
  /// digits never shift while counting down.
  String get toCountdown {
    final totalSeconds = inSeconds < 0 ? 0 : inSeconds;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Formatting helpers for the "ends 10:28" line.
extension ClockTimeExtension on DateTime {
  /// `HH:MM` in 24-hour form.
  String get toWallClock => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
