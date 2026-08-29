import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_switch.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_lock_overlay.dart';

import '../../../database.test_util.dart';
import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';
import '../../../widgettest.test_util.dart';

void main() {
  late ProviderContainer container;
  late BlockerProfileRepository profiles;
  late MockAppLauncherRepository launcher;

  setUpAll(() {
    registerFallbackValue(const AppLibraryEntry(name: 'fallback'));
  });

  setUp(() async {
    final database = createTestDatabase();
    profiles = BlockerProfileRepository(dao: BlockerDao(database));
    launcher = MockAppLauncherRepository();
    await profiles.createProfile(
      name: 'Deep Work',
      items: const [
        BlockedItem(id: 0, name: 'youtube.com', kind: BlockedItemKind.site),
        BlockedItem(id: 0, name: 'Slack', kind: BlockedItemKind.app),
      ],
    );

    container = createContainer(
      overrides: [
        blockerProfileRepositoryProvider.overrideWithValue(profiles),
        focusSessionRepositoryProvider.overrideWithValue(FocusSessionRepository(dao: FocusDao(database))),
        blockerEnforcementRepositoryProvider.overrideWith((ref) => FakeBlockerEnforcementRepository()),
        appLauncherRepositoryProvider.overrideWithValue(launcher),
      ],
    );
  });

  testWidgets('Given a profile with two entries, '
      'when the blocker card is shown, '
      'then it lists both with their kinds', (tester) async {
    // Given / When
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );

    // Then
    expect(find.text('youtube.com'), findsOneWidget);
    expect(find.text('Slack'), findsOneWidget);
    expect(find.text('site'), findsOneWidget);
    expect(find.text('app'), findsOneWidget);
  });

  testWidgets('Given an idle blocker card, '
      'when the switch is turned on, '
      'then the card goes dark and the lock animation plays', (tester) async {
    // Given
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );
    expect(container.read(blockerServiceProvider), isFalse);

    // When
    await tester.tap(find.byType(UiSwitch));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Then
    expect(container.read(blockerServiceProvider), isTrue);
    expect(find.byType(BlockerLockOverlay), findsOneWidget);

    final card = tester.widget<AnimatedContainer>(
      find.descendant(of: find.byType(BlockerCard), matching: find.byType(AnimatedContainer)).first,
    );
    final decoration = card.decoration! as BoxDecoration;
    expect(decoration.color, UiColor.bgDark);

    // ... and once the animation has played the overlay stops drawing, so it does
    // not sit on the card as a transparent layer
    await tester.pumpAndSettle();
    expect(find.descendant(of: find.byType(BlockerLockOverlay), matching: find.byType(Opacity)), findsNothing);
  });

  testWidgets('Given the "Choose app…" link, '
      'when an app is picked, '
      'then it joins the profile as an app carrying its bundle id', (tester) async {
    // Given
    when(
      launcher.chooseApp,
    ).thenAnswer((_) async => const AppLibraryEntry(name: 'Figma', bundleId: 'com.figma.Desktop'));
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );

    // When
    await tester.tap(find.text('Choose app…'.toUpperCase()));
    await tester.pumpAndSettle();

    // Then — the card's own drift stream needs a real tick to pick up the write, so
    // this waits on the stream directly (under `runAsync`, real sqlite I/O) rather than
    // asserting the very next pumped frame.
    final updated = await tester.runAsync(
      () => profiles
          .watchProfiles()
          .firstWhere((rows) => rows.single.items.any((item) => item.name == 'Figma'))
          .timeout(const Duration(seconds: 5)),
    );
    final added = updated!.single.items.firstWhere((item) => item.name == 'Figma');
    expect(added.kind, BlockedItemKind.app);
    expect(added.bundleId, 'com.figma.Desktop');
  });

  testWidgets('Given an enabled entry, '
      'when its row is tapped, '
      'then it is excluded from the profile', (tester) async {
    // Given
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );

    // When
    await tester.tap(find.text('Slack'));
    await tester.pumpAndSettle();

    // Then
    final profile = (await profiles.watchProfiles().first).single;
    expect(profile.items.firstWhere((item) => item.name == 'Slack').enabled, isFalse);
    expect(profile.enabledItems.map((item) => item.name), ['youtube.com']);
  });
}
