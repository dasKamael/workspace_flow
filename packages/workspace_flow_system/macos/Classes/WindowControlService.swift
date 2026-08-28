import Cocoa
import ApplicationServices

/// Moves and resizes other applications' windows through the accessibility API.
enum WindowControlService {
  static func isTrusted() -> Bool {
    AXIsProcessTrusted()
  }

  /// Shows the system prompt that leads to Privacy & Security › Accessibility.
  static func requestPermission() {
    let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
    _ = AXIsProcessTrustedWithOptions(options)
  }

  /// Positions the front window of `processId`.
  ///
  /// An app that was just launched has no window yet, so this polls until one appears
  /// or `timeoutMs` runs out, rather than failing on the first try.
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

    func attempt() {
      if let window = frontWindow(of: element) {
        completion(apply(rect: rect, to: window))
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
        let window = frontWindow(of: element),
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

  private static func frontWindow(of application: AXUIElement) -> AXUIElement? {
    var value: AnyObject?
    guard
      AXUIElementCopyAttributeValue(application, kAXWindowsAttribute as CFString, &value) == .success,
      let windows = value as? [AXUIElement]
    else { return nil }
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
