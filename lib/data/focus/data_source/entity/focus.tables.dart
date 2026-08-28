import 'package:drift/drift.dart';
import 'package:workspace_flow/data/blocker/data_source/entity/blocker.tables.dart';

/// One focus session.
///
/// `plannedMinutes` is `0` for an open-end session. `completed` is true when the
/// countdown ran out or the user stopped it, false while it is still running.
@DataClassName('FocusSessionEntity')
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get plannedMinutes => integer()();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}

/// An attempt to reach a blocked app or site while a profile was armed.
///
/// Feeds the "Blocked today" tile and the "· n blocked" counter.
@DataClassName('BlockedAttemptEntity')
class BlockedAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get attemptedAt => dateTime()();
  TextColumn get target => text().withLength(min: 1, max: 300)();
  IntColumn get profileId => integer().nullable().references(BlockerProfiles, #id, onDelete: KeyAction.setNull)();
}
