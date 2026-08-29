import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';

part 'blocker_enforcement.repository.g.dart';

/// Actually keeps the user out of blocked apps and sites.
///
/// On macOS, apps are caught the moment they activate (`NSWorkspace` notification) and
/// hidden; domains are caught by polling the frontmost browser's active tab through
/// AppleScript and redirecting it. See `BlockerEnforcementService.swift`.
abstract interface class BlockerEnforcementRepository {
  /// Starts enforcing [items]. Called when the blocker switch is turned on and again
  /// whenever the armed profile or its entries change.
  ///
  /// [blockedPageBaseUrl] is where a blocked site's tab is redirected — the content is
  /// entirely the Dart side's concern; enforcement only needs somewhere to send the
  /// browser.
  Future<void> arm(List<BlockedItem> items, {required String blockedPageBaseUrl});

  /// Stops enforcing.
  Future<void> disarm();

  /// Exempts [target] (an app's name/bundle id, or a domain) from enforcement for
  /// [duration], and restores whatever it was blocked from (unhides the app, or
  /// navigates the tab back).
  Future<void> allowTemporarily(String target, Duration duration);

  /// Emits the name of an app or domain each time an attempt was intercepted.
  Stream<String> get attempts;

  /// Emits the target each time "Unlock" was tapped on the blocked page for it.
  Stream<String> get unlockRequests;

  /// Whether enforcement is actually in effect — false for the fake.
  bool get isEnforcing;
}

/// The test double: records what it would block, blocks nothing.
class FakeBlockerEnforcementRepository implements BlockerEnforcementRepository {
  final StreamController<String> _attempts = StreamController<String>.broadcast();
  final StreamController<String> _unlockRequests = StreamController<String>.broadcast();

  /// The entries the last [arm] call was given — read by tests and the debug view.
  List<BlockedItem> armedItems = const [];

  /// The `blockedPageBaseUrl` the last [arm] call was given — read by tests.
  String? lastBlockedPageBaseUrl;

  /// The last [allowTemporarily] call, if any — read by tests.
  (String target, Duration duration)? lastAllowedTemporarily;

  @override
  Future<void> arm(List<BlockedItem> items, {required String blockedPageBaseUrl}) async {
    armedItems = items;
    lastBlockedPageBaseUrl = blockedPageBaseUrl;
  }

  @override
  Future<void> disarm() async => armedItems = const [];

  @override
  Future<void> allowTemporarily(String target, Duration duration) async => lastAllowedTemporarily = (target, duration);

  @override
  Stream<String> get attempts => _attempts.stream;

  @override
  Stream<String> get unlockRequests => _unlockRequests.stream;

  @override
  bool get isEnforcing => false;

  /// Simulates an intercepted attempt, so the counters and the blocked page can be
  /// exercised without the native side.
  void simulateAttempt(String target) => _attempts.add(target);

  /// Simulates tapping "Unlock" on the blocked page.
  void simulateUnlockRequest(String target) => _unlockRequests.add(target);

  void dispose() {
    _attempts.close();
    _unlockRequests.close();
  }
}

/// The macOS implementation.
class MacosBlockerEnforcementRepository implements BlockerEnforcementRepository {
  MacosBlockerEnforcementRepository({required this.channel}) {
    // Registered once, lazily, so construction alone does not touch the channel.
    channel.onCall('blockedAttempt', (arguments) async {
      final target = arguments['target']?.toString();
      if (target != null) _attempts.add(target);
      return null;
    });
    channel.onCall('blockedPageUnlock', (arguments) async {
      final target = arguments['target']?.toString();
      if (target != null) _unlockRequests.add(target);
      return null;
    });
  }

  final MacosBridgeChannel channel;
  final StreamController<String> _attempts = StreamController<String>.broadcast();
  final StreamController<String> _unlockRequests = StreamController<String>.broadcast();

  @override
  Future<void> arm(List<BlockedItem> items, {required String blockedPageBaseUrl}) =>
      channel.invoke<void>('armBlocker', {
        'items': [
          for (final item in items) {'name': item.name, 'kind': item.kind.name, 'bundleId': item.bundleId},
        ],
        'blockedPageBaseUrl': blockedPageBaseUrl,
      });

  @override
  Future<void> disarm() => channel.invoke<void>('disarmBlocker');

  @override
  Future<void> allowTemporarily(String target, Duration duration) =>
      channel.invoke<void>('unlockBlockerTarget', {'target': target, 'seconds': duration.inSeconds.toDouble()});

  @override
  Stream<String> get attempts => _attempts.stream;

  @override
  Stream<String> get unlockRequests => _unlockRequests.stream;

  @override
  bool get isEnforcing => true;
}

@Riverpod(keepAlive: true)
BlockerEnforcementRepository blockerEnforcementRepository(Ref ref) =>
    MacosBlockerEnforcementRepository(channel: ref.watch(macosBridgeChannelProvider));
