import Cocoa
import FlutterMacOS

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

  /// PNG data of each app's icon, keyed by bundle id.
  ///
  /// The layout overlay runs in a second engine with no plugins registered, so it
  /// cannot ask for these itself — the main engine fetches them and passes them along
  /// with the rest of the payload.
  static func icons(forBundleIds bundleIds: [String], size: CGFloat) -> [String: FlutterStandardTypedData] {
    var icons: [String: FlutterStandardTypedData] = [:]

    for bundleId in bundleIds {
      guard
        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId),
        let png = pngData(of: NSWorkspace.shared.icon(forFile: url.path), size: size)
      else { continue }
      icons[bundleId] = FlutterStandardTypedData(bytes: png)
    }

    return icons
  }

  /// Redraws the icon at the requested size — `NSImage.size` only changes the reported
  /// size, not the bitmap, so scaling has to go through a fresh image.
  private static func pngData(of image: NSImage, size: CGFloat) -> Data? {
    let target = NSSize(width: size, height: size)
    let resized = NSImage(size: target)

    resized.lockFocus()
    image.draw(in: NSRect(origin: .zero, size: target), from: .zero, operation: .sourceOver, fraction: 1)
    resized.unlockFocus()

    guard
      let tiff = resized.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff)
    else { return nil }

    return bitmap.representation(using: .png, properties: [:])
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
