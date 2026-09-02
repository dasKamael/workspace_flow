import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/data_source/entity/blocker.tables.dart';
import 'package:workspace_flow/data/focus/data_source/entity/focus.tables.dart';
import 'package:workspace_flow/data/project/data_source/entity/project.tables.dart';

part 'app_database.g.dart';

/// Name of the SQLite file inside the application support directory.
const String kDatabaseName = 'workspace_flow';

/// The app's local database.
///
/// Everything the app owns lives here: projects and their window layouts, blocker
/// profiles and their entries, the app library, and the session/attempt history the
/// statistics are derived from.
@DriftDatabase(
  tables: [
    Projects,
    ProjectWindows,
    AppLibraryEntries,
    BlockerProfiles,
    BlockedItems,
    BlockerSettings,
    FocusSessions,
    BlockedAttempts,
    FocusPresets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  /// `drift_flutter` defaults to the documents directory; on macOS the user's Documents
  /// folder is the wrong place for app data, so this pins it to Application Support.
  static QueryExecutor _open() => driftDatabase(
    name: kDatabaseName,
    native: DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory),
  );

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedSettingsDefaults();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // v2: a window or library entry can name a folder/file to open — a specific
      // project rather than just the app in general.
      if (from < 2) {
        await m.addColumn(appLibraryEntries, appLibraryEntries.documentPath);
        await m.addColumn(projectWindows, projectWindows.documentPath);
      }
      // v3: a blocked app added through the Finder picker carries its bundle id, so
      // enforcement can match the running process instead of just its display name.
      if (from < 3) {
        await m.addColumn(blockedItems, blockedItems.bundleId);
      }
      // v4: a window remembers which physical display it was arranged on, not just a
      // positional index — `NSScreen.screens`' array order can change across a sleep
      // or a monitor reconnect even with the same displays attached.
      if (from < 4) {
        await m.addColumn(projectWindows, projectWindows.displayId);
      }
      // v5: the blocker's "Unlock" allowance and the focus dial's presets become
      // user-configurable instead of hardcoded constants.
      if (from < 5) {
        await m.createTable(blockerSettings);
        await m.createTable(focusPresets);
        await _seedSettingsDefaults();
      }
    },
    beforeOpen: (details) async {
      // Required for the ON DELETE CASCADE / SET NULL clauses above to take effect.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Shared by a fresh install (`onCreate` already ran `createAll`, so the tables
  /// exist) and an upgrade from before v5 (`onUpgrade`, right after creating them) —
  /// either way the singleton settings row and the default presets need to exist.
  Future<void> _seedSettingsDefaults() async {
    await into(blockerSettings).insert(BlockerSettingsCompanion.insert(id: Value(1)));
    await batch(
      (batch) => batch.insertAll(focusPresets, [
        FocusPresetsCompanion.insert(label: 'Pomodoro', minutes: 25, sortOrder: Value(0)),
        FocusPresetsCompanion.insert(label: 'Deep work', minutes: 50, sortOrder: Value(1), isDefault: Value(true)),
        FocusPresetsCompanion.insert(label: 'Long haul', minutes: 90, sortOrder: Value(2)),
      ]),
    );
  }
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}
