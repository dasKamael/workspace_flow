import 'package:drift/drift.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/focus/data_source/entity/focus.tables.dart';

part 'focus.dao.g.dart';

/// Database access for the session history, blocked attempts, and focus presets.
@DriftAccessor(tables: [FocusSessions, BlockedAttempts, FocusPresets])
class FocusDao extends DatabaseAccessor<AppDatabase> with _$FocusDaoMixin {
  FocusDao(super.db);

  Future<int> insertSession(FocusSessionsCompanion session) => into(focusSessions).insert(session);

  Future<void> finishSession(int id, {required DateTime endedAt, required int elapsedSeconds}) =>
      (update(focusSessions)..where((s) => s.id.equals(id))).write(
        FocusSessionsCompanion(
          endedAt: Value(endedAt),
          elapsedSeconds: Value(elapsedSeconds),
          completed: const Value(true),
        ),
      );

  Future<void> insertBlockedAttempt(BlockedAttemptsCompanion attempt) => into(blockedAttempts).insert(attempt);

  /// Completed sessions started within `[from, to)`.
  Stream<int> watchSessionCount({required DateTime from, required DateTime to}) {
    final count = focusSessions.id.count();
    final query = selectOnly(focusSessions)
      ..addColumns([count])
      ..where(
        focusSessions.completed.equals(true) &
            focusSessions.startedAt.isBiggerOrEqualValue(from) &
            focusSessions.startedAt.isSmallerThanValue(to),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// Blocked attempts within `[from, to)`.
  Stream<int> watchBlockedAttemptCount({required DateTime from, required DateTime to}) {
    final count = blockedAttempts.id.count();
    final query = selectOnly(blockedAttempts)
      ..addColumns([count])
      ..where(
        blockedAttempts.attemptedAt.isBiggerOrEqualValue(from) & blockedAttempts.attemptedAt.isSmallerThanValue(to),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  /// The editable focus presets, in display order. "Open end" is not stored here —
  /// the domain layer appends it as a fixed, non-deletable entry.
  Stream<List<FocusPresetEntity>> watchPresets() {
    final query = select(focusPresets)
      ..orderBy([(p) => OrderingTerm(expression: p.sortOrder), (p) => OrderingTerm(expression: p.id)]);
    return query.watch();
  }

  /// Replaces the whole preset list in one transaction — the settings screen saves a
  /// draft, exactly like [replaceItems] does for a blocker profile's entries.
  Future<void> replacePresets(List<FocusPresetsCompanion> presets) => transaction(() async {
    await delete(focusPresets).go();
    await batch((batch) => batch.insertAll(focusPresets, presets));
  });
}
