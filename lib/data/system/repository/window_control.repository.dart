import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/system/model/captured_window.dart';

part 'window_control.repository.g.dart';

/// Moves and resizes the windows of other applications through the accessibility API.
///
/// Every method here needs Accessibility permission; without it the native side reports
/// `accessibility_denied` and the caller surfaces the permission hint.
class WindowControlRepository {
  WindowControlRepository({required this.channel});

  final MacosBridgeChannel channel;

  /// Whether this process is trusted for accessibility (`AXIsProcessTrusted`).
  Future<bool> isAccessibilityTrusted() async => await channel.invoke<bool>('isAccessibilityTrusted') ?? false;

  /// Opens the system prompt that leads to Privacy & Security › Accessibility.
  Future<void> requestAccessibilityPermission() => channel.invoke<void>('requestAccessibilityPermission');

  /// The front window of every running app, with its absolute frame.
  ///
  /// The read counterpart to [positionWindow] — it reports exactly the windows a launch
  /// would move, so an arrangement made by hand can be captured as a layout. Returns an
  /// empty list without accessibility permission.
  Future<List<CapturedWindow>> captureWindows() async {
    final rows = await channel.invokeList('listWindows');
    return [
      for (final row in rows)
        CapturedWindow(
          name: row['name']?.toString() ?? '',
          bundleId: row['bundleId']?.toString() ?? '',
          x: _toDouble(row['x']),
          y: _toDouble(row['y']),
          width: _toDouble(row['width']),
          height: _toDouble(row['height']),
        ),
    ];
  }

  static double _toDouble(Object? value) => value is num ? value.toDouble() : 0;

  /// Positions the front window of [processId] at an absolute screen rectangle.
  ///
  /// Waits up to [timeout] for the window to exist — an app that was just launched has
  /// no window yet. Returns false when no window appeared in time.
  Future<bool> positionWindow({
    required int processId,
    required double x,
    required double y,
    required double width,
    required double height,
    Duration timeout = const Duration(seconds: 8),
  }) async =>
      await channel.invoke<bool>('positionWindow', {
        'processId': processId,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'timeoutMs': timeout.inMilliseconds,
      }) ??
      false;
}

@Riverpod(keepAlive: true)
WindowControlRepository windowControlRepository(Ref ref) =>
    WindowControlRepository(channel: ref.watch(macosBridgeChannelProvider));
