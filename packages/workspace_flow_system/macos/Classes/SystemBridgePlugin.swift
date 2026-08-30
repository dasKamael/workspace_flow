import Cocoa
import FlutterMacOS

/// The single method channel between Dart and AppKit.
///
/// Every case here has a typed counterpart in `data/system/repository/`; nothing else
/// in the app talks to the native side.
final class SystemBridgePlugin {
  static let channelName = "de.coodoo.workspace_flow/system"

  private let channel: FlutterMethodChannel

  /// The view the plugin was registered with. Its window does not exist yet at
  /// registration time, so it is resolved lazily when the status item is clicked.
  private weak var hostView: NSView?

  init(messenger: FlutterBinaryMessenger, hostView: NSView?) {
    self.channel = FlutterMethodChannel(name: Self.channelName, binaryMessenger: messenger)
    self.hostView = hostView

    StatusItemService.shared.configure(
      onOpen: { [weak self] in
        let window = self?.hostView?.window ?? NSApp.windows.first
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
      },
      onLaunchProject: { [weak self] projectId in
        self?.channel.invokeMethod("statusItemLaunchProject", arguments: ["projectId": projectId])
      },
      onToggleFocus: { [weak self] in
        self?.channel.invokeMethod("statusItemToggleFocus", arguments: nil)
      },
      onStartFocus: { [weak self] minutes in
        self?.channel.invokeMethod("statusItemStartFocus", arguments: ["minutes": minutes])
      }
    )

    // The overlay runs in its own engine; its result has to travel back to the main
    // one, which only this channel can reach.
    LayoutOverlayService.shared.configure { [weak self] method, arguments in
      self?.channel.invokeMethod(method, arguments: arguments)
    }

    // Same reasoning: "Unlock" is tapped in the blocked page's own engine, but only
    // the main engine holds the profile/session state needed to act on it.
    BlockedWindowService.shared.configure { [weak self] method, arguments in
      self?.channel.invokeMethod(method, arguments: arguments)
    }

    // Enforcement reports an intercepted app or domain the same way.
    BlockerEnforcementService.configure { [weak self] method, arguments in
      self?.channel.invokeMethod(method, arguments: arguments)
    }

    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]

    switch call.method {
    case "getScreens":
      result(ScreenService.screens())

    case "getInstalledApps":
      result(AppLauncherService.installedApps())

    case "getAppIcons":
      let bundleIds = arguments["bundleIds"] as? [String] ?? []
      let size = arguments["size"] as? Double ?? 128
      result(AppLauncherService.icons(forBundleIds: bundleIds, size: CGFloat(size)))

    case "launchApp":
      guard let bundleId = arguments["bundleId"] as? String else {
        result(Self.badArguments(call))
        return
      }
      AppLauncherService.launch(bundleId: bundleId) { processId in
        result(processId)
      }

    case "openUrl":
      guard let url = arguments["url"] as? String else {
        result(Self.badArguments(call))
        return
      }
      AppLauncherService.open(url: url)
      result(nil)

    case "chooseApp":
      let directory = arguments["directory"] as? String ?? "/Applications"
      AppLauncherService.chooseApp(directory: directory) { entry in
        result(entry)
      }

    case "chooseFolder":
      let directory = arguments["directory"] as? String ?? NSHomeDirectory()
      AppLauncherService.chooseFolder(directory: directory) { entry in
        result(entry)
      }

    case "launchAppWithDocument":
      guard
        let bundleId = arguments["bundleId"] as? String,
        let documentPath = arguments["documentPath"] as? String
      else {
        result(Self.badArguments(call))
        return
      }
      AppLauncherService.launchWithDocument(bundleId: bundleId, documentPath: documentPath) { processId in
        result(processId)
      }

    case "isAccessibilityTrusted":
      result(WindowControlService.isTrusted())

    case "requestAccessibilityPermission":
      WindowControlService.requestPermission()
      result(nil)

    case "listWindows":
      result(WindowControlService.listWindows())

    case "positionWindow":
      guard
        let processId = arguments["processId"] as? Int,
        let x = arguments["x"] as? Double,
        let y = arguments["y"] as? Double,
        let width = arguments["width"] as? Double,
        let height = arguments["height"] as? Double
      else {
        result(Self.badArguments(call))
        return
      }
      WindowControlService.positionWindow(
        processId: processId,
        rect: CGRect(x: x, y: y, width: width, height: height),
        timeoutMs: arguments["timeoutMs"] as? Int ?? 8000
      ) { success in
        result(success)
      }

    case "setStatusItemTitle":
      StatusItemService.shared.setTitle(arguments["title"] as? String)
      result(nil)

    case "setStatusItemProjects":
      let projects = (arguments["projects"] as? [[String: Any]] ?? []).compactMap { entry -> (id: Int, name: String)? in
        guard let id = entry["id"] as? Int, let name = entry["name"] as? String else { return nil }
        return (id: id, name: name)
      }
      StatusItemService.shared.setProjects(projects)
      result(nil)

    case "setStatusItemSessionRunning":
      StatusItemService.shared.setSessionRunning(arguments["isRunning"] as? Bool ?? false)
      result(nil)

    case "isLoginItemEnabled":
      result(LoginItemService.isEnabled())

    case "setLoginItemEnabled":
      guard let enabled = arguments["enabled"] as? Bool else {
        result(Self.badArguments(call))
        return
      }
      do {
        try LoginItemService.setEnabled(enabled)
        result(nil)
      } catch {
        result(FlutterError(code: "login_item_failed", message: error.localizedDescription, details: nil))
      }

    case "showLayoutOverlay":
      LayoutOverlayService.shared.show(payload: arguments)
      result(nil)

    case "hideLayoutOverlay":
      LayoutOverlayService.shared.hide()
      result(nil)

    case "showBlockedWindow":
      BlockedWindowService.shared.show(payload: arguments)
      result(nil)

    case "hideBlockedWindow":
      BlockedWindowService.shared.hide()
      result(nil)

    case "armBlocker":
      BlockerEnforcementService.arm(
        items: arguments["items"] as? [[String: Any]] ?? [],
        blockedPageBaseUrl: arguments["blockedPageBaseUrl"] as? String
      )
      result(nil)

    case "disarmBlocker":
      BlockerEnforcementService.disarm()
      result(nil)

    case "unlockBlockerTarget":
      guard let target = arguments["target"] as? String else {
        result(Self.badArguments(call))
        return
      }
      let seconds = arguments["seconds"] as? Double ?? 120
      BlockerEnforcementService.allowTemporarily(target: target, seconds: seconds)
      result(nil)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private static func badArguments(_ call: FlutterMethodCall) -> FlutterError {
    FlutterError(code: "bad_arguments", message: "Missing or malformed arguments for \(call.method)", details: nil)
  }
}
