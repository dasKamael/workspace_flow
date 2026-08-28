import Cocoa
import FlutterMacOS

/// Shows the blocked page in its own borderless window.
///
/// macOS has no `FlutterEngineGroup`, so this runs a second standalone `FlutterEngine`
/// started at the `blockedPage` Dart entry point. That keeps the page available while
/// the main window is hidden during a session. The engine registers no plugins — the
/// page only needs its own method channel.
final class BlockedWindowService {
  static let shared = BlockedWindowService()

  private var engine: FlutterEngine?
  private var window: NSWindow?
  private var channel: FlutterMethodChannel?

  private static let windowSize = NSSize(width: 700, height: 340)
  private static let channelName = "de.coodoo.workspace_flow/blocked_page"

  private init() {}

  func show(payload: [String: Any]) {
    if window == nil {
      createWindow()
    }

    channel?.invokeMethod("update", arguments: payload)
    window?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  func hide() {
    window?.orderOut(nil)
  }

  private func createWindow() {
    let engine = FlutterEngine(name: "blocked_page", project: nil, allowHeadlessExecution: true)
    guard engine.run(withEntrypoint: "blockedPage") else { return }
    self.engine = engine

    let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: engine.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "dismiss" {
        self?.hide()
      }
      result(nil)
    }
    self.channel = channel

    let window = NSWindow(
      contentRect: NSRect(origin: .zero, size: Self.windowSize),
      styleMask: [.borderless],
      backing: .buffered,
      defer: false
    )
    window.contentViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    window.isOpaque = false
    window.backgroundColor = .clear
    window.level = .floating
    window.center()
    self.window = window
  }
}
