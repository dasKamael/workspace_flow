import Cocoa
import FlutterMacOS

/// A borderless window that can still take keyboard input.
///
/// Borderless windows never become key by default, which would leave esc and return
/// dead in the overlay.
final class LayoutOverlayWindow: NSWindow {
  override var canBecomeKey: Bool { true }
  override var canBecomeMain: Bool { true }
}

/// Shows the layout overlay across every screen.
///
/// A second `FlutterEngine` at the `layoutOverlay` entry point renders the same window
/// tiles the editor sheet shows, but at full size on the real displays. The window
/// spans the union of all `visibleFrame`s, so the menu bar and the Dock stay clear and
/// the surface matches exactly the area a project launch positions windows into.
final class LayoutOverlayService {
  static let shared = LayoutOverlayService()

  private var engine: FlutterEngine?
  private var window: NSWindow?
  private var channel: FlutterMethodChannel?

  /// Called when the overlay is applied or cancelled, so the main engine can be told.
  private var onResult: ((_ method: String, _ arguments: Any?) -> Void)?

  private static let channelName = "de.coodoo.workspace_flow/layout_overlay"

  private init() {}

  func configure(onResult: @escaping (_ method: String, _ arguments: Any?) -> Void) {
    self.onResult = onResult
  }

  func show(payload: [String: Any]) {
    guard let frame = Self.unionOfVisibleFrames() else { return }

    if window == nil {
      createWindow(frame: frame)
    } else {
      window?.setFrame(frame, display: true)
    }

    channel?.invokeMethod("update", arguments: payload)
    window?.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
  }

  func hide() {
    window?.orderOut(nil)
  }

  /// The rectangle covering every display's visible area, in AppKit coordinates.
  private static func unionOfVisibleFrames() -> NSRect? {
    let frames = NSScreen.screens.map(\.visibleFrame)
    guard var union = frames.first else { return nil }
    for frame in frames.dropFirst() {
      union = union.union(frame)
    }
    return union
  }

  private func createWindow(frame: NSRect) {
    let engine = FlutterEngine(name: "layout_overlay", project: nil, allowHeadlessExecution: true)
    guard engine.run(withEntrypoint: "layoutOverlay") else { return }
    self.engine = engine

    let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: engine.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "apply", "cancel":
        self?.hide()
        self?.onResult?(call.method == "apply" ? "layoutOverlayApplied" : "layoutOverlayCancelled", call.arguments)
      default:
        break
      }
      result(nil)
    }
    self.channel = channel

    let window = LayoutOverlayWindow(
      contentRect: frame,
      styleMask: [.borderless],
      backing: .buffered,
      defer: false
    )
    let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    // The Flutter view draws an opaque backing of its own; without this the window
    // stays solid no matter how transparent the Dart side paints.
    controller.backgroundColor = .clear

    window.contentViewController = controller
    window.isOpaque = false
    window.backgroundColor = .clear
    // A shadow around a screen-filling window only shows up as a dark rim.
    window.hasShadow = false
    window.level = .floating
    // Follows the user across spaces and sits alongside full-screen apps.
    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    window.setFrame(frame, display: false)
    self.window = window
  }
}
