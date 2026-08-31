import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/blocked_window.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_error_reason.enum.dart';
import 'package:workspace_flow/domain/blocker/model/blocker_profile.dart';
import 'package:workspace_flow/domain/blocker/service/blocked_page_server.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';

import '../../../database.test_util.dart';
import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// Skips the real `HttpServer.bind` — this test only cares that enforcement was told
/// *some* base URL, not that a socket actually opened.
class _FakeBlockedPageServerService extends BlockedPageServerService {
  @override
  Future<String> build() async => 'http://127.0.0.1:0';
}

/// Lets a test force `arm`/`disarm` to fail, to exercise `BlockerService`'s error
/// handling without a real native failure.
class _ThrowingBlockerEnforcementRepository extends FakeBlockerEnforcementRepository {
  bool throwOnArm = false;
  bool throwOnDisarm = false;

  @override
  Future<void> arm(List<BlockedItem> items, {required String blockedPageBaseUrl}) async {
    if (throwOnArm) throw Exception('arm failed');
    return super.arm(items, blockedPageBaseUrl: blockedPageBaseUrl);
  }

  @override
  Future<void> disarm() async {
    if (throwOnDisarm) throw Exception('disarm failed');
    return super.disarm();
  }
}

/// The enforcement side (native detection) is a fake here; this only checks that an
/// intercepted attempt is turned into the right side effects — the blocked-today stat
/// and the blocked page itself, which nothing previously wired up at all.
void main() {
  late ProviderContainer container;
  late _ThrowingBlockerEnforcementRepository enforcement;
  late MockBlockedWindowRepository blockedWindow;
  late MockMenuBarRepository menuBar;
  late BlockerProfileRepository profiles;

  setUpAll(() {
    registerFallbackValue(<BlockerProfile>[]);
  });

  setUp(() async {
    final database = createTestDatabase();
    profiles = BlockerProfileRepository(dao: BlockerDao(database));
    enforcement = _ThrowingBlockerEnforcementRepository();
    blockedWindow = MockBlockedWindowRepository();
    menuBar = MockMenuBarRepository();
    when(
      () => blockedWindow.show(
        target: any(named: 'target'),
        profileName: any(named: 'profileName'),
        unlockMinutes: any(named: 'unlockMinutes'),
        unlocksLeft: any(named: 'unlocksLeft'),
      ),
    ).thenAnswer((_) async {});
    when(() => menuBar.setBlockerProfiles(any())).thenAnswer((_) async {});
    when(() => menuBar.setArmedProfile(any())).thenAnswer((_) async {});
    when(() => menuBar.armProfileRequests).thenAnswer((_) => const Stream<int>.empty());
    when(() => menuBar.disarmProfileRequests).thenAnswer((_) => const Stream<void>.empty());

    await profiles.createProfile(
      name: 'Deep Work',
      items: const [
        BlockedItem(id: 0, name: 'Slack', kind: BlockedItemKind.app),
        BlockedItem(id: 0, name: 'youtube.com', kind: BlockedItemKind.site),
      ],
    );

    container = createContainer(
      overrides: [
        blockerProfileRepositoryProvider.overrideWithValue(profiles),
        focusSessionRepositoryProvider.overrideWithValue(FocusSessionRepository(dao: FocusDao(database))),
        blockerEnforcementRepositoryProvider.overrideWith((ref) => enforcement),
        blockedWindowRepositoryProvider.overrideWithValue(blockedWindow),
        blockedPageServerServiceProvider.overrideWith(() => _FakeBlockedPageServerService()),
        menuBarRepositoryProvider.overrideWithValue(menuBar),
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

  test('Given an armed profile with a site, '
      'when the site is intercepted, '
      'then no floating window is shown — the browser tab is the blocked page already', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // When
    enforcement.simulateAttempt('youtube.com');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then — a site's redirect already lands the browser on the blocked page itself
    verifyNever(
      () => blockedWindow.show(
        target: any(named: 'target'),
        profileName: any(named: 'profileName'),
        unlockMinutes: any(named: 'unlockMinutes'),
        unlocksLeft: any(named: 'unlocksLeft'),
      ),
    );
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

  test('Given the blocker profiles, '
      'when the list changes, '
      'then the menu bar dropdown is rebuilt with it', () async {
    // Given / When
    container.read(blockerServiceProvider);
    await container.read(blockerProfilesProvider.future);

    // Then
    final profile = (await profiles.watchProfiles().first).single;
    verify(() => menuBar.setBlockerProfiles([profile])).called(1);
  });

  test('Given a profile chosen to arm from the menu bar dropdown, '
      'when the request arrives, '
      'then that profile is armed and the dropdown is told its name', () async {
    // Given
    final armProfileRequests = StreamController<int>();
    when(() => menuBar.armProfileRequests).thenAnswer((_) => armProfileRequests.stream);
    container.read(blockerServiceProvider);
    final profile = (await profiles.watchProfiles().first).single;

    // When
    armProfileRequests.add(profile.id);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    expect(container.read(blockerServiceProvider), isTrue);
    verify(() => menuBar.setArmedProfile('Deep Work')).called(1);
  });

  test('Given the dropdown\'s "Disarm" entry is chosen, '
      'when the request arrives, '
      'then the blocker is disarmed', () async {
    // Given
    final disarmProfileRequests = StreamController<void>();
    when(() => menuBar.disarmProfileRequests).thenAnswer((_) => disarmProfileRequests.stream);
    container.read(blockerServiceProvider);
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // When
    disarmProfileRequests.add(null);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    expect(container.read(blockerServiceProvider), isFalse);
    verify(() => menuBar.setArmedProfile(null)).called(greaterThanOrEqualTo(1));
  });

  test('Given an armed profile, '
      'when a browser reports its Automation permission was denied, '
      'then the error service records a sitePermissionDenied reason', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // When
    enforcement.simulatePermissionDenied('com.google.Chrome');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Then
    expect(container.read(blockerErrorServiceProvider), BlockerErrorReason.sitePermissionDenied);
  });

  test('Given the enforcement repository fails to arm, '
      'when setArmed(armed: true) is called, '
      'then the blocker stays disarmed and the error service records an armFailed reason', () async {
    // Given
    enforcement.throwOnArm = true;

    // When
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);

    // Then
    expect(container.read(blockerServiceProvider), isFalse);
    expect(container.read(blockerErrorServiceProvider), BlockerErrorReason.armFailed);
  });

  test('Given an armed profile whose enforcement repository fails to disarm, '
      'when setArmed(armed: false) is called, '
      'then the blocker still reports disarmed and the error service records a disarmFailed reason', () async {
    // Given
    await container.read(blockerServiceProvider.notifier).setArmed(armed: true);
    enforcement.throwOnDisarm = true;

    // When
    await container.read(blockerServiceProvider.notifier).setArmed(armed: false);

    // Then
    expect(container.read(blockerServiceProvider), isFalse);
    expect(container.read(blockerErrorServiceProvider), BlockerErrorReason.disarmFailed);
  });
}
