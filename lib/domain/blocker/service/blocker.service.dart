import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';

part 'blocker.service.g.dart';

/// Whether the blocker is armed, and what it is enforcing.
///
/// Arming is independent of projects and of the timer: a profile can run on its own.
@Riverpod(keepAlive: true)
class BlockerService extends _$BlockerService {
  StreamSubscription<String>? _attempts;

  @override
  bool build() {
    ref.onDispose(() => _attempts?.cancel());
    return false;
  }

  /// Arms or disarms the blocker with the currently selected profile.
  Future<void> setArmed({required bool armed}) async {
    if (armed == state) return;

    final enforcement = ref.read(blockerEnforcementRepositoryProvider);

    if (!armed) {
      await _attempts?.cancel();
      _attempts = null;
      await enforcement.disarm();
      state = false;
      return;
    }

    final profile = await _selectedProfile();
    await enforcement.arm(profile?.enabledItems ?? const []);
    _attempts = enforcement.attempts.listen((target) => _recordAttempt(target, profile?.id));
    state = true;
  }

  /// Re-applies the armed profile after its entries changed.
  Future<void> reapply() async {
    if (!state) return;
    final profile = await _selectedProfile();
    await ref.read(blockerEnforcementRepositoryProvider).arm(profile?.enabledItems ?? const []);
  }

  Future<BlockerProfile?> _selectedProfile() async {
    // Awaited so arming right after startup does not run against an empty list.
    await ref.read(blockerProfilesProvider.future);
    return ref.read(selectedProfileProvider);
  }

  void _recordAttempt(String target, int? profileId) =>
      unawaited(ref.read(focusSessionRepositoryProvider).recordBlockedAttempt(target: target, profileId: profileId));
}
