import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/database/app_database.dart';

/// An in-memory [AppDatabase], closed at the end of the test.
AppDatabase createTestDatabase() {
  final database = AppDatabase(NativeDatabase.memory());
  addTearDown(database.close);
  return database;
}
