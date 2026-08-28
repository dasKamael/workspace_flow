import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';

part 'menu_bar.repository.g.dart';

/// Drives the `NSStatusItem` that shows the running session in the menu bar.
class MenuBarRepository {
  MenuBarRepository({required this.channel});

  final MacosBridgeChannel channel;

  /// Shows [title] (the countdown) in the menu bar.
  Future<void> showCountdown(String title) => channel.invoke<void>('setStatusItemTitle', {'title': title});

  /// Removes the countdown when no session is running.
  Future<void> hide() => channel.invoke<void>('setStatusItemTitle', {'title': null});
}

@Riverpod(keepAlive: true)
MenuBarRepository menuBarRepository(Ref ref) => MenuBarRepository(channel: ref.watch(macosBridgeChannelProvider));
