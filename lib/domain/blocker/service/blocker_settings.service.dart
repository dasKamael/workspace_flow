import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_settings.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_unlock_settings.dart';

part 'blocker_settings.service.g.dart';

/// The persisted "Unlock" allowance, kept in sync with the database.
@Riverpod(keepAlive: true)
Stream<BlockerUnlockSettings> blockerUnlockSettings(Ref ref) =>
    ref.watch(blockerSettingsRepositoryProvider).watchSettings();

/// Saving the unlock allowance — separate from the stream above the same way
/// [BlockerProfileService] sits next to `blockerProfilesProvider`, so the settings
/// screen never has to reach past this layer into the repository itself.
@Riverpod(keepAlive: true)
class BlockerSettingsService extends _$BlockerSettingsService {
  @override
  void build() {}

  Future<void> save({required int unlockMinutes, required int unlocksPerSession}) => ref
      .read(blockerSettingsRepositoryProvider)
      .save(unlockMinutes: unlockMinutes, unlocksPerSession: unlocksPerSession);
}
