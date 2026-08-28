import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  tables: [Projects, ProjectWindows, AppLibraryEntries, BlockerProfiles, BlockedItems, FocusSessions, BlockedAttempts],
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      // v2: a window or library entry can name a folder/file to open — a specific
      // project rather than just the app in general.
      if (from < 2) {
        await m.addColumn(appLibraryEntries, appLibraryEntries.documentPath);
        await m.addColumn(projectWindows, projectWindows.documentPath);
      }
    },
    beforeOpen: (details) async {
      // Required for the ON DELETE CASCADE / SET NULL clauses above to take effect.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
}
