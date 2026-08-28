import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_stats.freezed.dart';

/// Counters shown under the start button and in the "Blocked today" tile.
///
/// Both are derived by query from the session and attempt tables rather than kept as
/// running counters, so they stay correct across restarts and midnight.
@freezed
abstract class FocusStats with _$FocusStats {
  const factory FocusStats({@Default(0) int sessionsToday, @Default(0) int blockedToday}) = _FocusStats;
}
