import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'macos_bridge.channel.g.dart';

/// Thrown when the native side reports a failure.
class MacosBridgeException implements Exception {
  const MacosBridgeException(this.code, this.message);

  final String code;
  final String? message;

  @override
  String toString() => 'MacosBridgeException($code): $message';
}

/// The single [MethodChannel] to the macOS runner.
///
/// Everything that needs AppKit — screen geometry, launching apps, moving other apps'
/// windows through the accessibility API, the status item, the blocked-page window and
/// the login item — goes through here. Repositories in `data/system/repository/` give
/// each of those a typed face; nothing else talks to this class.
class MacosBridgeChannel {
  MacosBridgeChannel({MethodChannel? channel}) : _channel = channel ?? const MethodChannel(channelName);

  static const String channelName = 'de.coodoo.workspace_flow/system';

  final MethodChannel _channel;

  /// Invokes [method] and returns the decoded result.
  ///
  /// [PlatformException]s are re-thrown as [MacosBridgeException] so callers never have
  /// to know that a method channel is involved.
  Future<T?> invoke<T>(String method, [Map<String, Object?>? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on PlatformException catch (error) {
      throw MacosBridgeException(error.code, error.message);
    } on MissingPluginException {
      throw const MacosBridgeException('unimplemented', 'The macOS bridge is not available on this platform');
    }
  }

  /// Invokes [method] expecting a list of maps (screens, installed apps, …).
  Future<List<Map<String, Object?>>> invokeList(String method, [Map<String, Object?>? arguments]) async {
    final result = await invoke<List<Object?>>(method, arguments);
    return (result ?? const [])
        .whereType<Map<Object?, Object?>>()
        .map((entry) => entry.map((key, value) => MapEntry(key.toString(), value)))
        .toList();
  }

  /// Handlers for calls the native side makes back into Dart, keyed by method name.
  final Map<String, Future<Object?> Function(Map<String, Object?> arguments)> _handlers = {};

  /// Registers a handler for one inbound [method].
  ///
  /// Keyed by method rather than replacing a single channel-wide handler: the moment a
  /// second feature needs a callback, one would silently unregister the other.
  void onCall(String method, Future<Object?> Function(Map<String, Object?> arguments) handler) {
    final isFirst = _handlers.isEmpty;
    _handlers[method] = handler;
    if (isFirst) _channel.setMethodCallHandler(_dispatch);
  }

  Future<Object?> _dispatch(MethodCall call) async {
    final handler = _handlers[call.method];
    if (handler == null) return null;

    final arguments = call.arguments;
    return handler(
      arguments is Map ? arguments.map((key, value) => MapEntry(key.toString(), value)) : const <String, Object?>{},
    );
  }
}

@Riverpod(keepAlive: true)
MacosBridgeChannel macosBridgeChannel(Ref ref) => MacosBridgeChannel();
