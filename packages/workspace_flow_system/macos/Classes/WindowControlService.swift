import Cocoa
import ApplicationServices

/// Moves and resizes other applications' windows through the accessibility API.
enum WindowControlService {
  static func isTrusted() -> Bool {
    AXIsProcessTrusted()
  }

  /// When to reapply a window's rect after it was first set successfully, in seconds
  /// from that moment — a decaying schedule spanning a few seconds, long enough to
  /// outlast VS Code's own extension/workspace loading before it restores its
  /// remembered window frame for that folder.
  private static let reapplyDelays: [TimeInterval] = [0.3, 0.8, 1.6, 3.0]

  /// Shows the system prompt that leads to Privacy & Security › Accessibility.
  static func requestPermission() {
    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
    _ = AXIsProcessTrustedWithOptions(options)
  }

  /// How long to hold out for a genuinely new window before falling back to whatever
  /// is merely focused. Re-opening a document the app already has a window for — the
  /// exact case "Re-arrange" hits on a second run — creates no new window at all: the
  /// app just refocuses the existing one, so waiting for a "new" one that will never
  /// come would otherwise run out the clock on every single window.
  private static let newWindowGrace: TimeInterval = 1.5

  /// Positions a window of `processId`.
  ///
  /// An app that was just launched has no window yet, so this polls until one appears
  /// or `timeoutMs` runs out, rather than failing on the first try. If
  /// `AppLauncherService` recorded a pre-open snapshot for this process — it was
  /// already running when we asked it to open one more document — a window absent
  /// from that snapshot is preferred, since `kAXWindowsAttribute` has no defined order
  /// and an already-open window could otherwise just as easily be picked as the new
  /// one. But when no such new window shows up within `newWindowGrace`, the focused
  /// window is used anyway, snapshot or not — the document was very likely already
  /// open, and the app refocused that existing window instead of creating one.
  ///
  /// The rect is applied more than once: some AX implementations do not fully commit a
  /// position/size change from a single call, and several apps — VS Code among them —
  /// restore their *own* last-used frame for a document shortly after opening it,
  /// silently overwriting whatever we just set. VS Code in particular can take a
  /// couple of seconds to do this while it loads extensions and workspace state, so a
  /// single quick follow-up is not enough; reapplying on a short decaying schedule
  /// keeps winning that race for a few seconds without the caller having to wait for
  /// any of it.
  static func positionWindow(
    processId: Int,
    rect: CGRect,
    timeoutMs: Int,
    completion: @escaping (Bool) -> Void
  ) {
    guard isTrusted() else {
      NSLog("[WindowControl] pid=\(processId) aborted: not trusted for accessibility")
      completion(false)
      return
    }

    let startedAt = Date()
    let graceDeadline = startedAt.addingTimeInterval(newWindowGrace)
    let deadline = startedAt.addingTimeInterval(Double(timeoutMs) / 1000)
    let element = AXUIElementCreateApplication(pid_t(processId))
    let before = AppLauncherService.consumePreOpenSnapshot(processId: processId)
    NSLog("[WindowControl] pid=\(processId) start rect=\(rect) timeoutMs=\(timeoutMs) before.count=\(before.count)")

    func attempt() {
      let elapsed = Date().timeIntervalSince(startedAt)
      let allowFallback = before.isEmpty || Date() >= graceDeadline
      if let window = resolveWindow(of: element, excluding: before, allowFallback: allowFallback) {
        NSLog("[WindowControl] pid=\(processId) resolved a window after \(elapsed)s")
        let succeeded = apply(rect: rect, to: window)
        NSLog("[WindowControl] pid=\(processId) apply succeeded=\(succeeded)")
        completion(succeeded)

        if succeeded {
          for delay in reapplyDelays {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
              _ = apply(rect: rect, to: window)
            }
          }
        }
        return
      }
      guard Date() < deadline else {
        NSLog("[WindowControl] pid=\(processId) timed out after \(elapsed)s with no window at all")
        completion(false)
        return
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: attempt)
    }

    attempt()
  }

  /// Every window `processId`'s app element currently reports — the "before" half of
  /// the new-window diff `positionWindow` needs when the app is already running.
  static func currentWindows(processId: Int) -> [AXUIElement] {
    let element = AXUIElementCreateApplication(pid_t(processId))
    var value: AnyObject?
    guard
      AXUIElementCopyAttributeValue(element, kAXWindowsAttribute as CFString, &value) == .success,
      let windows = value as? [AXUIElement]
    else { return [] }
    return windows
  }

  /// The front window of every regular running app, with its frame.
  ///
  /// This is the read counterpart to `positionWindow`: it captures exactly the windows
  /// a launch would later move, so a layout taken from the current desktop can be
  /// restored faithfully. Frames come back in the same top-left coordinate space
  /// `ScreenService` reports, so Dart never has to know about AppKit's flipped origin.
  static func listWindows() -> [[String: Any]] {
    guard isTrusted() else { return [] }

    let ownPid = ProcessInfo.processInfo.processIdentifier
    var windows: [[String: Any]] = []

    for application in NSWorkspace.shared.runningApplications {
      guard
        application.activationPolicy == .regular,
        application.processIdentifier != ownPid,
        let bundleId = application.bundleIdentifier
      else { continue }

      let element = AXUIElementCreateApplication(application.processIdentifier)
      guard
        let window = resolveWindow(of: element, excluding: [], allowFallback: true),
        let frame = frameOf(window),
        // Palettes and inspectors are not worth capturing as a layout.
        frame.width >= minimumCapturedEdge, frame.height >= minimumCapturedEdge
      else { continue }

      windows.append([
        "name": application.localizedName ?? bundleId,
        "bundleId": bundleId,
        "x": frame.origin.x,
        "y": frame.origin.y,
        "width": frame.width,
        "height": frame.height,
      ])
    }

    return windows
  }

  /// Windows narrower or shorter than this are treated as tool panels, not layout.
  private static let minimumCapturedEdge: CGFloat = 200

  private static func frameOf(_ window: AXUIElement) -> CGRect? {
    var positionValue: AnyObject?
    var sizeValue: AnyObject?

    guard
      AXUIElementCopyAttributeValue(window, kAXPositionAttribute as CFString, &positionValue) == .success,
      AXUIElementCopyAttributeValue(window, kAXSizeAttribute as CFString, &sizeValue) == .success
    else { return nil }

    var origin = CGPoint.zero
    var size = CGSize.zero

    guard
      AXValueGetValue(positionValue as! AXValue, .cgPoint, &origin),
      AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
    else { return nil }

    return CGRect(origin: origin, size: size)
  }

  /// Resolves the window to act on.
  ///
  /// - A window present now but absent from [before] is unambiguously the one we just
  ///   opened, and wins whenever one exists — regardless of [allowFallback].
  /// - Failing that: if [before] is empty (a fresh launch, or a plain "activate" step
  ///   with no document) or [allowFallback] is set (no new window turned up within the
  ///   grace period, so the document was likely already open and got refocused instead
  ///   of duplicated), the app's currently focused window is used — set by
  ///   `configuration.activates = true` on the launch side, and a better signal than
  ///   `kAXWindowsAttribute`'s undefined ordering in any case.
  /// - Otherwise `nil`, so the caller keeps polling for a genuinely new window.
  private static func resolveWindow(
    of application: AXUIElement,
    excluding before: [AXUIElement],
    allowFallback: Bool
  ) -> AXUIElement? {
    var value: AnyObject?
    guard
      AXUIElementCopyAttributeValue(application, kAXWindowsAttribute as CFString, &value) == .success,
      let windows = value as? [AXUIElement]
    else {
      NSLog("[WindowControl] kAXWindowsAttribute unavailable for this application element")
      return nil
    }
    NSLog("[WindowControl] windows.count=\(windows.count) before.count=\(before.count) allowFallback=\(allowFallback)")

    // Only meaningful when `before` is non-empty: against an empty snapshot, every
    // window trivially "isn't in it", so this would just return `windows.first` under
    // another name — exactly the undefined-order pick the focused-window fallback
    // below exists to avoid. That matters whenever `before` is empty but the app is
    // already running with more than one window, e.g. a second project's plain
    // `launchApp` (no document) activating an app that some other project also uses.
    if !before.isEmpty, let fresh = windows.first(where: { candidate in !before.contains { CFEqual($0, candidate) } }) {
      NSLog("[WindowControl] resolveWindow: picked a fresh window not in the before-snapshot")
      return fresh
    }

    guard before.isEmpty || allowFallback else {
      NSLog("[WindowControl] resolveWindow: no fresh window yet, fallback not allowed — will keep polling")
      return nil
    }

    var focusedValue: AnyObject?
    if
      AXUIElementCopyAttributeValue(application, kAXFocusedWindowAttribute as CFString, &focusedValue) == .success,
      let focusedWindow = focusedValue
    {
      NSLog("[WindowControl] resolveWindow: picked the focused window")
      return (focusedWindow as! AXUIElement)
    }

    NSLog("[WindowControl] resolveWindow: no focused window either, falling back to windows.first (count=\(windows.count))")
    return windows.first
  }

  private static func apply(rect: CGRect, to window: AXUIElement) -> Bool {
    var origin = rect.origin
    var size = rect.size

    guard
      let positionValue = AXValueCreate(.cgPoint, &origin),
      let sizeValue = AXValueCreate(.cgSize, &size)
    else { return false }

    // Size first, then position: a window that is clamped to its minimum size would
    // otherwise be pushed off the target screen before it shrinks.
    let sizeResult = AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
    let positionResult = AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, positionValue)

    if sizeResult != .success || positionResult != .success {
      NSLog("[WindowControl] apply failed: sizeResult=\(sizeResult.rawValue) positionResult=\(positionResult.rawValue)")
    }

    return sizeResult == .success && positionResult == .success
  }
}
