import Cocoa

/// Launches apps and websites, and discovers what is installed.
enum AppLauncherService {
  private static let applicationDirectories = [
    "/Applications",
    "/System/Applications",
    NSString(string: "~/Applications").expandingTildeInPath,
  ]

  /// Every `.app` in the standard application directories.
  static func installedApps() -> [[String: Any]] {
    var seen = Set<String>()
    var apps: [[String: Any]] = []

    for directory in applicationDirectories {
      let contents = (try? FileManager.default.contentsOfDirectory(atPath: directory)) ?? []
      for entry in contents where entry.hasSuffix(".app") {
        let path = (directory as NSString).appendingPathComponent(entry)
        guard let bundle = Bundle(path: path), let bundleId = bundle.bundleIdentifier else { continue }
        guard seen.insert(bundleId).inserted else { continue }
        apps.append(["name": (entry as NSString).deletingPathExtension, "bundleId": bundleId, "path": path])
      }
    }

    return apps.sorted { ($0["name"] as? String ?? "") < ($1["name"] as? String ?? "") }
  }

  /// Opens an app and returns its process id, which window positioning needs.
  ///
  /// An app that is already running is activated rather than started twice.
  static func launch(bundleId: String, completion: @escaping (Int?) -> Void) {
    if let running = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).first {
      running.activate(options: [])
      completion(Int(running.processIdentifier))
      return
    }

    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) else {
      completion(nil)
      return
    }

    let configuration = NSWorkspace.OpenConfiguration()
    configuration.activates = true
    NSWorkspace.shared.openApplication(at: url, configuration: configuration) { application, _ in
      completion(application.map { Int($0.processIdentifier) })
    }
  }

  static func open(url string: String) {
    guard let url = URL(string: string) else { return }
    NSWorkspace.shared.open(url)
  }

  /// The real `NSOpenPanel`, restricted to applications.
  static func chooseApp(directory: String, completion: @escaping ([String: Any]?) -> Void) {
    let panel = NSOpenPanel()
    panel.canChooseFiles = true
    panel.canChooseDirectories = false
    panel.allowsMultipleSelection = false
    panel.directoryURL = URL(fileURLWithPath: directory)
    panel.allowedContentTypes = [.application]
    panel.prompt = "Open"

    panel.begin { response in
      guard
        response == .OK,
        let url = panel.url,
        let bundle = Bundle(path: url.path),
        let bundleId = bundle.bundleIdentifier
      else {
        completion(nil)
        return
      }
      completion([
        "name": url.deletingPathExtension().lastPathComponent,
        "bundleId": bundleId,
        "path": url.path,
      ])
    }
  }
}
