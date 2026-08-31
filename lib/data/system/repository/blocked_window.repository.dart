import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';

part 'blocked_window.repository.g.dart';

/// Shows the blocked page in its own borderless window.
///
/// The native side runs it in a second Flutter engine so the main window can stay
/// hidden while a session is running.
class BlockedWindowRepository {
  BlockedWindowRepository({required this.channel});

  final MacosBridgeChannel channel;

  Future<void> show({
    required String target,
    required String profileName,
    String? projectName,
    String? endsAt,
    String? remaining,
    int unlockMinutes = 2,
    int unlocksLeft = 0,
  }) => channel.invoke<void>('showBlockedWindow', {
    'target': target,
    'profileName': profileName,
    'projectName': projectName,
    'endsAt': endsAt,
    'remaining': remaining,
    'unlockMinutes': unlockMinutes,
    'unlocksLeft': unlocksLeft,
  });

  Future<void> hide() => channel.invoke<void>('hideBlockedWindow');
}

@Riverpod(keepAlive: true)
BlockedWindowRepository blockedWindowRepository(Ref ref) =>
    BlockedWindowRepository(channel: ref.watch(macosBridgeChannelProvider));
