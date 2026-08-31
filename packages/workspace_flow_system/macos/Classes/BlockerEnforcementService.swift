import Cocoa

/// One armed entry, as sent from Dart.
private struct ArmedApp {
  let bundleId: String?
  let name: String
}

/// Enforces an armed blocker profile: hides blocked apps the moment they launch or
/// activate, and redirects a blocked domain out of the frontmost browser's active tab.
///
/// Apps are caught through `NSWorkspace.didLaunchApplicationNotification` (before the
/// app's window ever gets a chance to flash on screen) and `didActivateApplicationNotification`
/// — far cheaper than polling, and the latter fires again on every re-activation (Dock
/// click, ⌘-Tab), which is exactly what keeps a hidden app from simply being brought
/// back. Domains have no equivalent notification, so those are polled on a short timer,
/// and only while at least one is armed.
enum BlockerEnforcementService {
  private static let pollInterval: TimeInterval = 1

  /// Known scriptable browsers. Anything else — Firefox included — has no AppleScript
  /// tab access, so a domain armed against it cannot be enforced; that gap is accepted.
  private static let browserBundleIds: Set<String> = [
    "com.apple.Safari",
    "com.google.Chrome",
    "com.microsoft.edgemac",
    "com.brave.Browser",
    "company.thebrowser.Browser",
    "com.vivaldi.Vivaldi",
    "com.operasoftware.Opera",
  ]

  /// Apple Events error -1743 ("not authorized to send Apple events") — the browser's
  /// automation permission hasn't been granted (or was revoked) yet.
  private static let automationDeniedErrorNumber = -1743

  private static var armedApps: [ArmedApp] = []
  private static var armedDomains: [String] = []
  private static var activationObserver: NSObjectProtocol?
  private static var launchObserver: NSObjectProtocol?
  private static var pollTimer: Timer?

  /// Bundle ids already reported through `siteBlockingPermissionDenied` this armed
  /// session, so a 1s poll does not repeat the same failure forever.
  private static var reportedPermissionDenials: Set<String> = []

  /// Where a blocked domain's tab is redirected to — a local page the Dart side serves
  /// and owns entirely; this only ever needs the base URL to send the browser to.
  private static var blockedPageBaseUrl: String?

  /// The URL a domain pointed at right before it was redirected, so "Unlock" can
  /// restore it.
  private static var lastUrlByDomain: [String: String] = [:]

  /// Apps/domains temporarily exempt from enforcement, and until when.
  private static var temporarilyAllowedUntil: [String: Date] = [:]

  /// Reports back to Dart over the shared method channel — set once by
  /// `SystemBridgePlugin`, the same pattern `LayoutOverlayService` uses.
  private static var callback: ((String, [String: Any]) -> Void)?

  static func configure(callback: @escaping (String, [String: Any]) -> Void) {
    self.callback = callback
  }

  static func arm(items: [[String: Any]], blockedPageBaseUrl: String?) {
    armedApps = items.compactMap { item in
      guard (item["kind"] as? String) == "app", let name = item["name"] as? String else { return nil }
      return ArmedApp(bundleId: item["bundleId"] as? String, name: name)
    }
    armedDomains = items.compactMap { item in
      (item["kind"] as? String) == "site" ? (item["name"] as? String)?.lowercased() : nil
    }
    self.blockedPageBaseUrl = blockedPageBaseUrl

    if activationObserver == nil {
      activationObserver = NSWorkspace.shared.notificationCenter.addObserver(
        forName: NSWorkspace.didActivateApplicationNotification,
        object: nil,
        queue: .main,
        using: { notification in checkActivation(notification) }
      )
      launchObserver = NSWorkspace.shared.notificationCenter.addObserver(
        forName: NSWorkspace.didLaunchApplicationNotification,
        object: nil,
        queue: .main,
        using: { notification in checkActivation(notification) }
      )
      // The blocked app may already be frontmost the moment the blocker is armed.
      if let frontmost = NSWorkspace.shared.frontmostApplication {
        handlePossibleAppMatch(frontmost)
      }
    }

    if !armedDomains.isEmpty, pollTimer == nil {
      pollTimer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { _ in checkFrontmostBrowser() }
    } else if armedDomains.isEmpty {
      pollTimer?.invalidate()
      pollTimer = nil
    }
  }

  static func disarm() {
    armedApps = []
    armedDomains = []
    lastUrlByDomain = [:]
    temporarilyAllowedUntil = [:]
    reportedPermissionDenials = []

    if let observer = activationObserver {
      NSWorkspace.shared.notificationCenter.removeObserver(observer)
      activationObserver = nil
    }
    if let observer = launchObserver {
      NSWorkspace.shared.notificationCenter.removeObserver(observer)
      launchObserver = nil
    }
    pollTimer?.invalidate()
    pollTimer = nil
  }

  /// Exempts `target` (a bundle id, app name, or domain) from enforcement for `seconds`,
  /// and — for an app — brings it back to the foreground; for a domain, restores the tab
  /// it was blanked from.
  static func allowTemporarily(target: String, seconds: TimeInterval) {
    temporarilyAllowedUntil[target.lowercased()] = Date().addingTimeInterval(seconds)

    if let app = armedApps.first(where: { $0.name == target || $0.bundleId == target }) {
      let running = app.bundleId.flatMap { bundleId in
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first
      }
      running?.unhide()
      running?.activate(options: [])
      return
    }

    let domain = target.lowercased()
    guard let url = lastUrlByDomain[domain] else { return }
    for bundleId in browserBundleIds {
      guard NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first != nil else { continue }
      _ = runAppleScript(navigateScript(bundleId: bundleId, url: url), bundleId: bundleId)
    }
  }

  // ---------------------------------------------------------------- app activation

  private static func checkActivation(_ notification: Notification) {
    guard
      let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
    else { return }
    handlePossibleAppMatch(application)
  }

  private static func handlePossibleAppMatch(_ application: NSRunningApplication) {
    guard application.bundleIdentifier != Bundle.main.bundleIdentifier else { return }

    guard
      let matched = armedApps.first(where: { armed in
        if let bundleId = armed.bundleId { return bundleId == application.bundleIdentifier }
        return armed.name.caseInsensitiveCompare(application.localizedName ?? "") == .orderedSame
      }),
      !isTemporarilyAllowed(application.bundleIdentifier ?? matched.name, matched.name)
    else { return }

    application.hide()
    callback?("blockedAttempt", ["target": matched.name])
  }

  // ---------------------------------------------------------------------- websites

  /// Checked and re-blocked on every tick with no "already redirected" debounce: the
  /// redirect below happens synchronously within the same tick it is detected in, so
  /// the next tick already sees the new (blocked-page) URL and naturally does nothing —
  /// *unless* the tab left the blocked page again, which is exactly the case that
  /// matters: the browser's own back button lands right back on the real domain, and
  /// that has to be caught and redirected again just like a fresh visit would be.
  private static func checkFrontmostBrowser() {
    guard
      let frontmost = NSWorkspace.shared.frontmostApplication,
      let bundleId = frontmost.bundleIdentifier,
      browserBundleIds.contains(bundleId),
      let url = runAppleScript(urlScript(bundleId: bundleId), bundleId: bundleId),
      let host = URLComponents(string: url)?.host?.lowercased()
    else { return }

    guard
      let domain = armedDomains.first(where: { host == $0 || host.hasSuffix(".\($0)") }),
      !isTemporarilyAllowed(domain)
    else { return }

    lastUrlByDomain[domain] = url
    _ = runAppleScript(
      navigateScript(bundleId: bundleId, url: blockedPageUrl(target: domain, returnUrl: url)),
      bundleId: bundleId
    )
    callback?("blockedAttempt", ["target": domain])
  }

  /// The local page a blocked tab is redirected to — content and "Unlock" are entirely
  /// the Dart side's concern (`BlockedPageServerService`); this just points there.
  /// Falls back to a blank tab in the unexpected case the server was never armed with.
  private static func blockedPageUrl(target: String, returnUrl: String) -> String {
    guard let baseUrl = blockedPageBaseUrl else { return "about:blank" }
    let allowed = CharacterSet.urlQueryAllowed
    let encodedTarget = target.addingPercentEncoding(withAllowedCharacters: allowed) ?? target
    let encodedReturnUrl = returnUrl.addingPercentEncoding(withAllowedCharacters: allowed) ?? returnUrl
    return "\(baseUrl)/blocked?target=\(encodedTarget)&returnUrl=\(encodedReturnUrl)"
  }

  private static func urlScript(bundleId: String) -> String {
    if bundleId == "com.apple.Safari" {
      return "tell application \"Safari\" to return URL of front document"
    }
    let name = browserName(for: bundleId)
    return "tell application \"\(name)\" to return URL of active tab of front window"
  }

  private static func navigateScript(bundleId: String, url: String) -> String {
    if bundleId == "com.apple.Safari" {
      return "tell application \"Safari\" to set URL of front document to \"\(url)\""
    }
    let name = browserName(for: bundleId)
    return "tell application \"\(name)\" to set URL of active tab of front window to \"\(url)\""
  }

  private static func browserName(for bundleId: String) -> String {
    switch bundleId {
    case "com.google.Chrome": return "Google Chrome"
    case "com.microsoft.edgemac": return "Microsoft Edge"
    case "com.brave.Browser": return "Brave Browser"
    case "company.thebrowser.Browser": return "Arc"
    case "com.vivaldi.Vivaldi": return "Vivaldi"
    case "com.operasoftware.Opera": return "Opera"
    default: return "Safari"
    }
  }

  /// Runs `source`, swallowing any error — a browser that was quit mid-check should not
  /// crash or spam a log. If the error is Apple Events being denied for `bundleId`,
  /// reports it once per armed session so the UI can tell the user site blocking isn't
  /// actually working for that browser instead of failing silently forever.
  private static func runAppleScript(_ source: String, bundleId: String? = nil) -> String? {
    var error: NSDictionary?
    let result = NSAppleScript(source: source)?.executeAndReturnError(&error)

    if
      let error, let bundleId,
      (error["NSAppleScriptErrorNumber"] as? Int) == automationDeniedErrorNumber,
      !reportedPermissionDenials.contains(bundleId)
    {
      reportedPermissionDenials.insert(bundleId)
      callback?("siteBlockingPermissionDenied", ["bundleId": bundleId])
    }

    return error == nil ? result?.stringValue : nil
  }

  private static func isTemporarilyAllowed(_ keys: String...) -> Bool {
    keys.contains { key in
      guard let until = temporarilyAllowedUntil[key.lowercased()] else { return false }
      return until > Date()
    }
  }
}
