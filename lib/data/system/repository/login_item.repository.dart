import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';

part 'login_item.repository.g.dart';

/// Registers the app as a login item via `SMAppService`.
class LoginItemRepository {
  LoginItemRepository({required this.channel});

  final MacosBridgeChannel channel;

  Future<bool> isEnabled() async => await channel.invoke<bool>('isLoginItemEnabled') ?? false;

  Future<void> setEnabled({required bool enabled}) => channel.invoke<void>('setLoginItemEnabled', {'enabled': enabled});
}

@Riverpod(keepAlive: true)
LoginItemRepository loginItemRepository(Ref ref) => LoginItemRepository(channel: ref.watch(macosBridgeChannelProvider));
