import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocker_unlock_settings.freezed.dart';

/// How generous the blocker's "Unlock" button is — how long an exemption lasts and how
/// many a single armed session gets. User-configurable; see the `k`-prefixed constants
/// in `BlockerService` for the fallback used before this has loaded.
@freezed
abstract class BlockerUnlockSettings with _$BlockerUnlockSettings {
  const factory BlockerUnlockSettings({required int unlockMinutes, required int unlocksPerSession}) =
      _BlockerUnlockSettings;
}
