import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';

part 'focus_session.repository.g.dart';

/// Records focus sessions and blocked attempts, and derives the daily counters.
class FocusSessionRepository {
  FocusSessionRepository({required this.dao});

  final FocusDao dao;

  /// Starts a session and returns its id, to be passed back to [finishSession].
  Future<int> startSession({required int plannedMinutes}) =>
      dao.insertSession(FocusSessionsCompanion.insert(startedAt: clock.now(), plannedMinutes: plannedMinutes));

  Future<void> finishSession({required int id, required int elapsedSeconds}) =>
      dao.finishSession(id, endedAt: clock.now(), elapsedSeconds: elapsedSeconds);

  Future<void> recordBlockedAttempt({required String target, int? profileId}) => dao.insertBlockedAttempt(
    BlockedAttemptsCompanion.insert(attemptedAt: clock.now(), target: target, profileId: Value(profileId)),
  );

  /// Completed sessions started today.
  Stream<int> watchSessionsToday() {
    final (from, to) = _today();
    return dao.watchSessionCount(from: from, to: to);
  }

  /// Blocked attempts recorded today.
  Stream<int> watchBlockedAttemptsToday() {
    final (from, to) = _today();
    return dao.watchBlockedAttemptCount(from: from, to: to);
  }

  /// Local-time day boundaries. Read through `clock` so tests can pin the date.
  (DateTime, DateTime) _today() {
    final now = clock.now();
    final from = DateTime(now.year, now.month, now.day);
    return (from, from.add(const Duration(days: 1)));
  }
}

@Riverpod(keepAlive: true)
FocusSessionRepository focusSessionRepository(Ref ref) =>
    FocusSessionRepository(dao: FocusDao(ref.watch(appDatabaseProvider)));
