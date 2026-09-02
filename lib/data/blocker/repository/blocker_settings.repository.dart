import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_unlock_settings.dart';

part 'blocker_settings.repository.g.dart';

/// Reads and writes the blocker's "Unlock" allowance.
class BlockerSettingsRepository {
  BlockerSettingsRepository({required this.dao});

  final BlockerDao dao;

  Stream<BlockerUnlockSettings> watchSettings() => dao
      .watchSettings()
      .map((row) => BlockerUnlockSettings(unlockMinutes: row.unlockMinutes, unlocksPerSession: row.unlocksPerSession));

  Future<void> save({required int unlockMinutes, required int unlocksPerSession}) =>
      dao.updateSettings(unlockMinutes: unlockMinutes, unlocksPerSession: unlocksPerSession);
}

@Riverpod(keepAlive: true)
BlockerSettingsRepository blockerSettingsRepository(Ref ref) =>
    BlockerSettingsRepository(dao: BlockerDao(ref.watch(appDatabaseProvider)));
