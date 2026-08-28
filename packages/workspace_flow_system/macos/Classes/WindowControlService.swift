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

  /// Positions a window of `processId`.
  ///
  /// An app that was just launched has no window yet, so this polls until one appears
  /// or `timeoutMs` runs out, rather than failing on the first try. If
  /// `AppLauncherService` recorded a pre-open snapshot for this process — it was
  /// already running when we asked it to open one more document — only a window
  /// absent from that snapshot counts: `kAXWindowsAttribute` has no defined order, so
  /// without this an already-open window could just as easily be the one that gets
  /// repositioned instead of the new one.
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
      completion(false)
      return
    }

    let deadline = Date().addingTimeInterval(Double(timeoutMs) / 1000)
    let element = AXUIElementCreateApplication(pid_t(processId))
    let before = AppLauncherService.consumePreOpenSnapshot(processId: processId)

    func attempt() {
      if let window = frontWindow(of: element, excluding: before) {
        _ = apply(rect: rect, to: window)
        let succeeded = apply(rect: rect, to: window)
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
        let window = frontWindow(of: element, excluding: []),
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
  /// - If [before] is non-empty (the app was already running with those windows open),
  ///   only a window that is not one of them qualifies — returning `nil` otherwise, so
  ///   the caller keeps polling instead of settling for a pre-existing window.
  /// - Otherwise this is either a fresh launch (any window is unambiguously the new
  ///   one) or a plain "launch/activate" step with no document, for which the app's
  ///   currently focused window — set by `configuration.activates = true` on the
  ///   launch side — is the best available signal, `kAXWindowsAttribute`'s ordering
  ///   being undefined.
  private static func frontWindow(of application: AXUIElement, excluding before: [AXUIElement]) -> AXUIElement? {
    var value: AnyObject?
    guard
      AXUIElementCopyAttributeValue(application, kAXWindowsAttribute as CFString, &value) == .success,
      let windows = value as? [AXUIElement]
    else { return nil }

    if !before.isEmpty {
      return windows.first { candidate in !before.contains { CFEqual($0, candidate) } }
    }

    var focusedValue: AnyObject?
    if
      AXUIElementCopyAttributeValue(application, kAXFocusedWindowAttribute as CFString, &focusedValue) == .success,
      let focusedWindow = focusedValue
    {
      return (focusedWindow as! AXUIElement)
    }

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

    return sizeResult == .success && positionResult == .success
  }
}
