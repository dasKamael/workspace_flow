import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/domain/focus/model/focus_preset.dart';

part 'focus_preset.repository.g.dart';

/// Reads and writes the user-editable focus presets.
class FocusPresetRepository {
  FocusPresetRepository({required this.dao});

  final FocusDao dao;

  Stream<List<FocusPreset>> watchPresets() => dao.watchPresets().map(
    (rows) => [
      for (final row in rows) FocusPreset(id: row.id, label: row.label, minutes: row.minutes, isDefault: row.isDefault),
    ],
  );

  /// Replaces the whole list, in the given order — the settings screen saves a draft.
  Future<void> savePresets(List<FocusPreset> presets) => dao.replacePresets([
    for (final (index, preset) in presets.indexed)
      FocusPresetsCompanion.insert(
        label: preset.label,
        minutes: preset.minutes,
        sortOrder: Value(index),
        isDefault: Value(preset.isDefault),
      ),
  ]);
}

@Riverpod(keepAlive: true)
FocusPresetRepository focusPresetRepository(Ref ref) =>
    FocusPresetRepository(dao: FocusDao(ref.watch(appDatabaseProvider)));
