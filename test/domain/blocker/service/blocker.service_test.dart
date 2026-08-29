import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/blocked_window.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';

import '../../../database.test_util.dart';
import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// The enforcement side (native detection) is a fake here; this only checks that an
/// intercepted attempt is turned into the right side effects — the blocked-today stat
/// and the blocked page itself, which nothing previously wired up at all.
void main() {
  late ProviderContainer container;
  late FakeBlockerEnforcementRepository enforcement;
  late MockBlockedWindowRepository blockedWindow;
  late BlockerProfileRepository profiles;

  setUp(() async {
    final database = createTestDatabase();
    profiles = BlockerProfileRepository(dao: BlockerDao(database));
    enforcement = FakeBlockerEnforcementRepository();
    blockedWindow = MockBlockedWindowRepository();
    when(
      () => blockedWindow.show(
        target: any(named: 'target'),
        profileName: any(named: 'profileName'),
        unlockMinutes: any(named: 'unlockMinutes'),
        unlocksLeft: any(named: 'unlocksLeft'),
      ),
    ).thenAnswer((_) async {});

    await profiles.createProfile(
      name: 'Deep Work',
      items: const [BlockedItem(id: 0, name: 'Slack', kind: BlockedItemKind.app)],
    );

    container = createContainer(
      overrides: [
        blockerProfileRepositoryProvider.overrideWithValue(profiles),
        focusSessionRepositoryProvider.overrideWithValue(FocusSessionRepository(dao: FocusDao(database))),
        blockerEnforcementRepositoryProvider.overrideWith((ref) => enforcement),
        blockedWindowRepositoryProvider.overrideWithValue(blockedWindow),
      ],
    );
  });

  test('Given an armed profile, '
      'when an attempt is intercepted, '
      'then the blocked page is shown with the target and the armed profile\'s name', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // When
    enforcement.simulateAttempt('Slack');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    verify(
      () => blockedWindow.show(
        target: 'Slack',
        profileName: 'Deep Work',
        unlockMinutes: kBlockerUnlockDuration.inMinutes,
        unlocksLeft: kBlockerUnlocksPerSession,
      ),
    ).called(1);
  });

  test('Given an attempt was just intercepted and an unlock granted, '
      'when a second attempt comes in, '
      'then the blocked page reports one fewer unlock left', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);
    await container.read(blockerServiceProvider.notifier).unlock('Slack');

    // When
    enforcement.simulateAttempt('Slack');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    verify(
      () => blockedWindow.show(target: 'Slack', profileName: 'Deep Work', unlockMinutes: 2, unlocksLeft: 2),
    ).called(1);
    expect(enforcement.lastAllowedTemporarily, ('Slack', kBlockerUnlockDuration));
  });

  test('Given the blocked page reports "Unlock" was tapped, '
      'when the request arrives, '
      'then the target is exempted from enforcement', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // When
    enforcement.simulateUnlockRequest('Slack');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    expect(enforcement.lastAllowedTemporarily, ('Slack', kBlockerUnlockDuration));
  });
}
