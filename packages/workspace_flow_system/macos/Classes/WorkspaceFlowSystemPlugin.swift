import Cocoa
import FlutterMacOS

/// Entry point of the macOS bridge.
///
/// Flutter calls `register(with:)` through the generated plugin registrant, so the
/// channel is live before the first Dart frame and the Runner needs no wiring of its own.
public class WorkspaceFlowSystemPlugin: NSObject, FlutterPlugin {
  /// Held so the bridge — and its channel handler — outlives `register(with:)`.
  private static var bridge: SystemBridgePlugin?

  public static func register(with registrar: FlutterPluginRegistrar) {
    bridge = SystemBridgePlugin(messenger: registrar.messenger, hostView: registrar.view)
  }
}
