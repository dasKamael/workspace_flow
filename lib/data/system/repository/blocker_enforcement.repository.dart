import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';

part 'blocker_enforcement.repository.g.dart';

/// Actually keeps the user out of blocked apps and sites.
///
/// The target implementation on macOS polls `NSWorkspace.runningApplications` and hides
/// or terminates blocked apps, and writes the blocked domains into `/etc/hosts` through
/// a privileged helper (one-time admin approval). Neither is wired up yet — v1 ships
/// [FakeBlockerEnforcementRepository], which keeps the UI, the profiles and the
/// statistics fully working without enforcing anything.
abstract interface class BlockerEnforcementRepository {
  /// Starts enforcing [items]. Called when the blocker switch is turned on and again
  /// whenever the armed profile or its entries change.
  Future<void> arm(List<BlockedItem> items);

  /// Stops enforcing.
  Future<void> disarm();

  /// Emits the name of an app or domain each time an attempt was intercepted.
  Stream<String> get attempts;

  /// Whether enforcement is actually in effect — false for the fake.
  bool get isEnforcing;
}

/// The v1 implementation: records what it would block, blocks nothing.
class FakeBlockerEnforcementRepository implements BlockerEnforcementRepository {
  final StreamController<String> _attempts = StreamController<String>.broadcast();

  /// The entries the last [arm] call was given — read by tests and the debug view.
  List<BlockedItem> armedItems = const [];

  @override
  Future<void> arm(List<BlockedItem> items) async => armedItems = items;

  @override
  Future<void> disarm() async => armedItems = const [];

  @override
  Stream<String> get attempts => _attempts.stream;

  @override
  bool get isEnforcing => false;

  /// Simulates an intercepted attempt, so the counters and the blocked page can be
  /// exercised before the native side exists.
  void simulateAttempt(String target) => _attempts.add(target);

  void dispose() => _attempts.close();
}

/// The macOS implementation. Not reachable yet — see [BlockerEnforcementRepository].
class MacosBlockerEnforcementRepository implements BlockerEnforcementRepository {
  MacosBlockerEnforcementRepository({required this.channel});

  final MacosBridgeChannel channel;

  @override
  Future<void> arm(List<BlockedItem> items) => channel.invoke<void>('armBlocker', {
    'items': [
      for (final item in items) {'name': item.name, 'kind': item.kind.name},
    ],
  });

  @override
  Future<void> disarm() => channel.invoke<void>('disarmBlocker');

  @override
  Stream<String> get attempts => const Stream<String>.empty();

  @override
  bool get isEnforcing => true;
}

@Riverpod(keepAlive: true)
BlockerEnforcementRepository blockerEnforcementRepository(Ref ref) {
  final repository = FakeBlockerEnforcementRepository();
  ref.onDispose(repository.dispose);
  return repository;
}
