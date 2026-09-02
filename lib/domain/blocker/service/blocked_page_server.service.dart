import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/data_source/blocked_page_server.dart';
import 'package:workspace_flow/domain/blocker/service/blocker.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_settings.service.dart';

part 'blocked_page_server.service.g.dart';

/// Owns the local server a blocked site is redirected to, and wires "Unlock" back
/// into [BlockerService].
///
/// Started once and never stopped for the life of the app — a browser tab can sit on
/// the blocked page long after disarming, and its "Unlock" link still needs somewhere
/// to land.
@Riverpod(keepAlive: true)
class BlockedPageServerService extends _$BlockedPageServerService {
  late final BlockedPageServer _server = BlockedPageServer(
    onUnlockRequested: (target) => ref.read(blockerServiceProvider.notifier).unlock(target),
    currentPageData: () => (
      profileName: ref.read(selectedProfileProvider)?.name ?? '',
      unlocksRemaining: ref.read(blockerServiceProvider.notifier).unlocksRemaining,
      unlockMinutes: ref.read(blockerUnlockSettingsProvider).value?.unlockMinutes ?? kBlockerUnlockDuration.inMinutes,
    ),
  );

  @override
  Future<String> build() async {
    await _server.start();
    ref.onDispose(_server.stop);
    return 'http://127.0.0.1:${_server.port}';
  }
}
