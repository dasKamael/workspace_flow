import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/blocked_window.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_error_reason.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/blocker/service/blocked_page_server.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';

part 'blocker.service.g.dart';

/// How long "Unlock" exempts a target from enforcement.
const Duration kBlockerUnlockDuration = Duration(minutes: 2);

/// How many unlocks a single armed session gets, reset every time the blocker is armed.
const int kBlockerUnlocksPerSession = 3;

/// The last arm/disarm failure or permission problem the UI hasn't shown yet, if any.
/// Set by [BlockerService], cleared by whoever displays it.
@Riverpod(keepAlive: true)
class BlockerErrorService extends _$BlockerErrorService {
  @override
  BlockerErrorReason? build() => null;

  void report(BlockerErrorReason reason) => state = reason;

  void clear() => state = null;
}

/// Whether the blocker is armed, what it is enforcing, and how many unlocks remain.
///
/// Arming is independent of projects and of the timer: a profile can run on its own.
@Riverpod(keepAlive: true)
class BlockerService extends _$BlockerService {
  StreamSubscription<String>? _attempts;
  StreamSubscription<String>? _unlockRequests;
  StreamSubscription<String>? _permissionDenied;

  @override
  bool build() {
    ref.onDispose(() {
      _attempts?.cancel();
      _unlockRequests?.cancel();
      _permissionDenied?.cancel();
    });

    final menuBar = ref.read(menuBarRepositoryProvider);
    ref.listen(blockerProfilesProvider, (_, next) {
      final profiles = next.valueOrNull;
      if (profiles == null) return;
      unawaited(menuBar.setBlockerProfiles(profiles).catchError((_) {}));
    }, fireImmediately: true);

    final armSubscription = menuBar.armProfileRequests.listen(_armFromMenuBar);
    final disarmSubscription = menuBar.disarmProfileRequests.listen((_) => setArmed(armed: false));
    ref.onDispose(armSubscription.cancel);
    ref.onDispose(disarmSubscription.cancel);

    // Published once up front, for the same reason the focus service does: `state` is
    // not readable until `build` itself has returned.
    Future.microtask(_publishArmedProfileToMenuBar);

    return false;
  }

  /// Arms [profileId] from the menu bar dropdown. The dropdown only offers this while
  /// idle — a stray/late request arriving after arming some other way is ignored rather
  /// than silently swapping the enforced profile out from under it.
  Future<void> _armFromMenuBar(int profileId) async {
    if (state) return;
    ref.read(selectedProfileServiceProvider.notifier).select(profileId);
    await setArmed(armed: true);
  }

  void _publishArmedProfileToMenuBar() {
    final name = state ? ref.read(selectedProfileProvider)?.name : null;
    unawaited(ref.read(menuBarRepositoryProvider).setArmedProfile(name).catchError((_) {}));
  }

  /// Unlocks left in the current armed session.
  int unlocksRemaining = kBlockerUnlocksPerSession;

  /// Arms or disarms the blocker with the currently selected profile.
  Future<void> setArmed({required bool armed}) async {
    if (armed == state) return;

    final enforcement = ref.read(blockerEnforcementRepositoryProvider);

    if (!armed) {
      await _attempts?.cancel();
      await _unlockRequests?.cancel();
      await _permissionDenied?.cancel();
      _attempts = null;
      _unlockRequests = null;
      _permissionDenied = null;
      try {
        await enforcement.disarm();
      } catch (_) {
        ref.read(blockerErrorServiceProvider.notifier).report(BlockerErrorReason.disarmFailed);
      }
      state = false;
      _publishArmedProfileToMenuBar();
      return;
    }

    final profile = await _selectedProfile();
    unlocksRemaining = kBlockerUnlocksPerSession;
    try {
      await enforcement.arm(profile?.enabledItems ?? const [], blockedPageBaseUrl: await _blockedPageBaseUrl());
    } catch (_) {
      ref.read(blockerErrorServiceProvider.notifier).report(BlockerErrorReason.armFailed);
      return;
    }
    _attempts = enforcement.attempts.listen((target) => _handleAttempt(target, profile));
    _unlockRequests = enforcement.unlockRequests.listen(unlock);
    _permissionDenied = enforcement.permissionDenied.listen(
      (_) => ref.read(blockerErrorServiceProvider.notifier).report(BlockerErrorReason.sitePermissionDenied),
    );
    state = true;
    _publishArmedProfileToMenuBar();
  }

  /// Re-applies the armed profile after its entries changed.
  Future<void> reapply() async {
    if (!state) return;
    final profile = await _selectedProfile();
    await ref
        .read(blockerEnforcementRepositoryProvider)
        .arm(profile?.enabledItems ?? const [], blockedPageBaseUrl: await _blockedPageBaseUrl());
  }

  Future<String> _blockedPageBaseUrl() => ref.read(blockedPageServerServiceProvider.future);

  /// Exempts [target] from enforcement for [kBlockerUnlockDuration], as long as a use
  /// remains. Called both from the blocked page's own "Unlock" button (via
  /// [BlockerEnforcementRepository.unlockRequests]) and, in principle, anywhere else
  /// that wants to grant one.
  Future<void> unlock(String target) async {
    if (unlocksRemaining <= 0) return;
    unlocksRemaining--;
    await ref.read(blockerEnforcementRepositoryProvider).allowTemporarily(target, kBlockerUnlockDuration);
  }

  Future<BlockerProfile?> _selectedProfile() async {
    // Awaited so arming right after startup does not run against an empty list.
    await ref.read(blockerProfilesProvider.future);
    return ref.read(selectedProfileProvider);
  }

  void _handleAttempt(String target, BlockerProfile? profile) {
    unawaited(ref.read(focusSessionRepositoryProvider).recordBlockedAttempt(target: target, profileId: profile?.id));

    // A site's redirect already lands the browser on the blocked page itself — no
    // separate window is needed, and popping one would pull focus over to this app
    // exactly the way switching apps to see it would. An app has no such page, so it
    // still gets the floating overlay; an unresolved target (should not normally
    // happen) falls back to showing it too, rather than blocking silently.
    final kind = profile?.items.where((item) => item.name == target).firstOrNull?.kind;
    if (kind == BlockedItemKind.site) return;

    unawaited(
      ref
          .read(blockedWindowRepositoryProvider)
          .show(
            target: target,
            profileName: profile?.name ?? '',
            unlocksLeft: unlocksRemaining,
            unlockMinutes: kBlockerUnlockDuration.inMinutes,
          ),
    );
  }
}
