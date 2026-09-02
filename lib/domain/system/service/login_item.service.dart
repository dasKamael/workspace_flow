import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/login_item.repository.dart';

part 'login_item.service.g.dart';

/// Whether Loom is registered to launch at login, via `SMAppService`.
@Riverpod(keepAlive: true)
class LoginItemService extends _$LoginItemService {
  @override
  Future<bool> build() => ref.read(loginItemRepositoryProvider).isEnabled();

  Future<void> setEnabled({required bool enabled}) async {
    await ref.read(loginItemRepositoryProvider).setEnabled(enabled: enabled);
    state = AsyncValue.data(await ref.read(loginItemRepositoryProvider).isEnabled());
  }
}
