import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocker.dao.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/focus/data_source/focus.dao.dart';
import 'package:workspace_flow/data/focus/repository/focus_session.repository.dart';
import 'package:workspace_flow/data/system/repository/blocker_enforcement.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocked_page_server.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_switch.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_lock_overlay.dart';

import '../../../database.test_util.dart';
import '../../../riverpod.test_util.dart';
import '../../../widgettest.test_util.dart';

/// A real `HttpServer.bind` never resolves inside a widget test's fake clock, so
/// arming never has to actually start one here.
class _FakeBlockedPageServerService extends BlockedPageServerService {
  @override
  Future<String> build() async => 'http://127.0.0.1:0';
}

void main() {
  late ProviderContainer container;
  late BlockerProfileRepository profiles;
  late FakeBlockerEnforcementRepository enforcement;

  setUp(() async {
    final database = createTestDatabase();
    profiles = BlockerProfileRepository(dao: BlockerDao(database));
    await profiles.createProfile(
      name: 'Deep Work',
      items: const [
        BlockedItem(id: 0, name: 'youtube.com', kind: BlockedItemKind.site),
        BlockedItem(id: 0, name: 'Slack', kind: BlockedItemKind.app),
      ],
    );
    enforcement = FakeBlockerEnforcementRepository();

    container = createContainer(
      overrides: [
        blockerProfileRepositoryProvider.overrideWithValue(profiles),
        focusSessionRepositoryProvider.overrideWithValue(FocusSessionRepository(dao: FocusDao(database))),
        blockerEnforcementRepositoryProvider.overrideWith((ref) => enforcement),
        // A real HttpServer bind never resolves inside the widget test's fake clock.
        blockedPageServerServiceProvider.overrideWith(() => _FakeBlockedPageServerService()),
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

  testWidgets('Given more than one profile, '
      'when the card is shown, '
      'then a "+" chip and exactly one pencil sit next to the selected profile', (tester) async {
    // Given
    await profiles.createProfile(name: 'Code', items: const []);

    // When
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );

    // Then — one edit button, next to whichever profile is selected, not the others
    expect(find.byWidgetPredicate((widget) => widget is UiSvgIcon && widget.path == UiIcon.pencil), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
  });

  testWidgets('Given the overview card, '
      'when it is shown, '
      'then there is no way to add an entry — that only happens in the profile editor', (tester) async {
    // Given / When
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );

    // Then
    expect(find.text('Choose app…'.toUpperCase()), findsNothing);
    expect(find.text('add app or domain'), findsNothing);
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

  testWidgets('Given an armed blocker card, '
      'when a browser reports its Automation permission was denied, '
      'then a snackbar tells the user site blocking needs permission', (tester) async {
    // Given
    await pumpAppWidget(
      tester,
      container: container,
      child: const SizedBox(width: 320, child: BlockerCard()),
    );
    await tester.tap(find.byType(UiSwitch));
    await tester.pumpAndSettle();

    // When
    enforcement.simulatePermissionDenied('com.google.Chrome');
    await tester.pump();
    await tester.pump();

    // Then
    expect(find.textContaining('Automation'), findsOneWidget);
  });
}
