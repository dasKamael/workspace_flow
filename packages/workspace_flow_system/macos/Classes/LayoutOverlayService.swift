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

/// One physical screen's own window, engine, and channel.
private struct ScreenSession {
  let engine: FlutterEngine
  let window: LayoutOverlayWindow
  let channel: FlutterMethodChannel
}

/// Shows the layout overlay across every screen — one native window per physical
/// display, not one window spanning all of them, and — unlike a first attempt at
/// this — one `FlutterEngine` per window too.
///
/// Two reasons collapse into the same design:
///  1. A `FlutterView`'s Metal layer has a single `contentsScale`, so one window
///     stretched across displays with different `backingScaleFactor`s (a Retina
///     built-in plus non-Retina externals, say) can only ever render correctly for
///     one of them.
///  2. A `FlutterEngine`'s public macOS API only ever accepts one `FlutterViewController`
///     — a second `initWithEngine:` on the same engine throws
///     `NSInternalInconsistencyException: "The engine already has a view controller
///     for the implicit view."` at runtime. The multi-view engine API this would
///     need is real, but it isn't reachable through the stable, public
///     `FlutterEngine`/`FlutterViewController` surface at this SDK version — only
///     through the separate, `master`-channel-only Dart windowing API, which isn't
///     an option here (see the file this replaced for that dead end).
///
/// So: N screens, N engines, N windows, N Dart isolates — each running the same
/// `layoutOverlay` entrypoint but only ever knowing about its own screen's tiles.
/// The draft layout that used to be one shared list in one isolate is now kept here
/// instead, one per-screen slice at a time, updated on every local edit and merged
/// back into one list only when the user actually applies.
final class LayoutOverlayService {
  static let shared = LayoutOverlayService()

  private var sessions: [Int: ScreenSession] = [:]

  /// Each screen's own current draft tiles, as last reported by its isolate. The
  /// merge of these — not anything Dart holds — is the source of truth for "apply".
  private var windowsByScreen: [Int: [[String: Any]]] = [:]

  private var screenChangeObserver: NSObjectProtocol?

  /// Called when the overlay is applied or cancelled, so the main engine can be told.
  private var onResult: ((_ method: String, _ arguments: Any?) -> Void)?

  private static let channelName = "de.coodoo.workspace_flow/layout_overlay"

  private init() {}

  func configure(onResult: @escaping (_ method: String, _ arguments: Any?) -> Void) {
    self.onResult = onResult
  }

  func show(payload: [String: Any]) {
    syncSessions()
    if screenChangeObserver == nil { observeScreenChanges() }

    let allWindows = payload["windows"] as? [[String: Any]] ?? []
    windowsByScreen = Dictionary(grouping: allWindows) { entry in (entry["screenIndex"] as? Int) ?? 0 }

    for (index, session) in sessions {
      var scoped = payload
      scoped["screenIndex"] = index
      scoped["windows"] = windowsByScreen[index] ?? []
      // Every screen's own row of "apps still available to place" has to know what's
      // already used on every *other* screen too, not just its own — this is that,
      // kept current afterwards by `broadcastAllWindows()`.
      scoped["allWindows"] = allWindows
      session.channel.invokeMethod("update", arguments: scoped)
    }

    for (index, session) in sessions {
      if index == mainScreenIndex() {
        session.window.makeKeyAndOrderFront(nil)
      } else {
        session.window.orderFront(nil)
      }
    }
    NSApp.activate(ignoringOtherApps: true)
  }

  func hide() {
    for session in sessions.values { session.window.orderOut(nil) }
  }

  /// Creates a session for every currently attached screen that doesn't have one yet,
  /// and closes any session whose screen is no longer attached.
  private func syncSessions() {
    let attached = Set(NSScreen.screens.indices)
    for index in Set(sessions.keys).subtracting(attached) {
      sessions[index]?.window.orderOut(nil)
      sessions.removeValue(forKey: index)
      windowsByScreen.removeValue(forKey: index)
    }

    for (index, screen) in NSScreen.screens.enumerated() where sessions[index] == nil {
      sessions[index] = makeSession(frame: screen.visibleFrame)
    }
  }

  private func makeSession(frame: NSRect) -> ScreenSession {
    let engine = FlutterEngine(name: "layout_overlay", project: nil, allowHeadlessExecution: true)
    _ = engine.run(withEntrypoint: "layoutOverlay")

    let channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: engine.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }

    let controller = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    // The Flutter view draws an opaque backing of its own; without this the window
    // stays solid no matter how transparent the Dart side paints.
    controller.backgroundColor = .clear

    let window = LayoutOverlayWindow(contentRect: frame, styleMask: [.borderless], backing: .buffered, defer: false)
    window.contentViewController = controller
    window.isOpaque = false
    window.backgroundColor = .clear
    // A shadow around a screen-filling window only shows up as a dark rim.
    window.hasShadow = false
    window.level = .floating
    // Follows the user across spaces and sits alongside full-screen apps.
    window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    window.setFrame(frame, display: false)

    return ScreenSession(engine: engine, window: window, channel: channel)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]

    switch call.method {
    case "windowsChanged":
      // Fire-and-forget bookkeeping: a screen tells native its current tiles after
      // every local edit, so a merge is ready the instant any window applies —
      // no round trip needed at that point, and no other screen is touched or
      // re-rendered by this.
      if let screenIndex = arguments["screenIndex"] as? Int, let windows = arguments["windows"] as? [[String: Any]] {
        windowsByScreen[screenIndex] = windows
        broadcastAllWindows()
      }

    case "moveWindowToScreen":
      // The origin screen already removed the tile from its own list (and reported
      // that via `windowsChanged`, same as any other edit). This has to do two
      // things, not just one: hand the tile to the destination screen's isolate so
      // it actually renders there, *and* fold it into `windowsByScreen` here too —
      // the destination isolate only ever reports its list back on its *own* next
      // local edit, so without this the moved tile would be invisible to "apply"
      // (and to every other screen's "already used" row) until the destination
      // happens to be edited some other way.
      if
        let window = arguments["window"] as? [String: Any],
        let targetScreenIndex = arguments["targetScreenIndex"] as? Int,
        let target = sessions[targetScreenIndex]
      {
        windowsByScreen[targetScreenIndex, default: []].append(window)
        broadcastAllWindows()
        target.channel.invokeMethod("windowAdded", arguments: window)
      }

    case "showDragPreview":
      // Purely a relay: a drag still in progress on one screen is hovering over
      // another's physical area, so that screen gets a live look at where it would
      // land — nothing here is part of the actual draft (`windowsByScreen`) until
      // the drag actually ends and `moveWindowToScreen` (or a plain in-bounds drop)
      // commits it for real.
      if
        let window = arguments["window"] as? [String: Any],
        let targetScreenIndex = arguments["targetScreenIndex"] as? Int,
        let target = sessions[targetScreenIndex]
      {
        target.channel.invokeMethod("dragPreview", arguments: window)
      }

    case "hideDragPreview":
      if let targetScreenIndex = arguments["targetScreenIndex"] as? Int, let target = sessions[targetScreenIndex] {
        target.channel.invokeMethod("hideDragPreview", arguments: nil)
      }

    case "apply", "cancel":
      hide()
      if call.method == "apply" {
        onResult?("layoutOverlayApplied", ["windows": mergedWindows()])
      } else {
        onResult?("layoutOverlayCancelled", nil)
      }

    default:
      break
    }
    result(nil)
  }

  private func mergedWindows() -> [[String: Any]] {
    sessions.keys.sorted().flatMap { windowsByScreen[$0] ?? [] }
  }

  /// Tells every screen what every screen now holds, so each one's "apps still
  /// available to place" row can exclude an app the *instant* it's used anywhere —
  /// not just once that screen happens to be edited some other way.
  private func broadcastAllWindows() {
    let merged = mergedWindows()
    for session in sessions.values {
      session.channel.invokeMethod("allWindowsChanged", arguments: merged)
    }
  }

  private func mainScreenIndex() -> Int? {
    NSScreen.screens.firstIndex(where: { $0 == NSScreen.main })
  }

  /// A monitor connected or disconnected while the overlay is open invalidates every
  /// window's geometry at once; there is no attempt to re-flow the in-progress
  /// arrangement, just a clean cancel so the user can reopen against the new setup.
  private func observeScreenChanges() {
    screenChangeObserver = NotificationCenter.default.addObserver(
      forName: NSApplication.didChangeScreenParametersNotification,
      object: nil,
      queue: .main,
      using: { [weak self] _ in
        guard let self, !self.sessions.isEmpty else { return }
        self.hide()
        self.onResult?("layoutOverlayCancelled", nil)
      }
    )
  }
}
