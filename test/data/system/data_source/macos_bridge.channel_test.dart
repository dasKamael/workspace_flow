import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';

/// Inbound calls are dispatched by method name. The previous single channel-wide
/// handler meant the second feature to register silently unhooked the first.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MacosBridgeChannel bridge;
  late MethodChannel channel;

  setUp(() {
    channel = const MethodChannel('test/bridge');
    bridge = MacosBridgeChannel(channel: channel);
  });

  /// Simulates the native side calling into Dart.
  Future<void> sendFromNative(String method, [Object? arguments]) => TestDefaultBinaryMessengerBinding
      .instance
      .defaultBinaryMessenger
      .handlePlatformMessage(channel.name, channel.codec.encodeMethodCall(MethodCall(method, arguments)), (_) {});

  test('Given handlers for two different methods, '
      'when both are called from the native side, '
      'then each one receives its own call', () async {
    // Given
    final received = <String, Map<String, Object?>>{};
    bridge.onCall('first', (arguments) async => received['first'] = arguments);
    bridge.onCall('second', (arguments) async => received['second'] = arguments);

    // When
    await sendFromNative('first', {'value': 1});
    await sendFromNative('second', {'value': 2});

    // Then — registering the second must not have unhooked the first
    expect(received['first'], {'value': 1});
    expect(received['second'], {'value': 2});
  });

  test('Given a call with no arguments, '
      'when it is dispatched, '
      'then the handler gets an empty map rather than a null', () async {
    // Given
    Map<String, Object?>? received;
    bridge.onCall('ping', (arguments) async => received = arguments);

    // When
    await sendFromNative('ping');

    // Then
    expect(received, isEmpty);
  });

  test('Given a method nobody registered for, '
      'when the native side calls it, '
      'then nothing happens instead of an error', () async {
    // Given
    bridge.onCall('known', (arguments) async => null);

    // When / Then
    await expectLater(sendFromNative('unknown'), completes);
  });
}
