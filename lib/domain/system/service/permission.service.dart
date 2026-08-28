import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';

part 'permission.service.g.dart';

/// Whether the app may move other apps' windows.
///
/// Without Accessibility permission a project can still launch its apps, but they land
/// wherever macOS puts them — the launch reports `needsAccessibilityPermission` so the
/// UI can offer the system settings.
@Riverpod(keepAlive: true)
class AccessibilityPermissionService extends _$AccessibilityPermissionService {
  @override
  Future<bool> build() => _read();

  Future<bool> _read() async {
    try {
      return await ref.read(windowControlRepositoryProvider).isAccessibilityTrusted();
    } on Object {
      return false;
    }
  }

  /// Opens the system prompt and re-reads the state afterwards.
  Future<void> request() async {
    try {
      await ref.read(windowControlRepositoryProvider).requestAccessibilityPermission();
    } on Object {
      // The prompt is best effort — the refresh below reports the real state.
    }
    state = AsyncValue.data(await _read());
  }

  Future<void> refresh() async => state = AsyncValue.data(await _read());
}
