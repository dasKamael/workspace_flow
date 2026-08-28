import 'package:drift/drift.dart';

/// A saved window layout.
@DataClassName('ProjectEntity')
class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

/// One window of a project layout.
///
/// `x`, `y`, `width` and `height` are percentages (0–100) of the target screen's
/// visible frame — see `ProjectWindow`.
@DataClassName('ProjectWindowEntity')
class ProjectWindows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get projectId => integer().references(Projects, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get bundleId => text().nullable()();
  TextColumn get url => text().nullable()();
  IntColumn get screenIndex => integer().withDefault(const Constant(0))();
  RealColumn get x => real()();
  RealColumn get y => real()();
  RealColumn get width => real()();
  RealColumn get height => real()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// Apps and websites offered as chips in the project editor.
@DataClassName('AppLibraryEntity')
class AppLibraryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get bundleId => text().nullable()();
  TextColumn get path => text().nullable()();
  TextColumn get url => text().nullable()();

  /// A given app or site appears once in the library.
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {name},
  ];
}
