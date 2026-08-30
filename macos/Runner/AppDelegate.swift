import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // The menu bar icon is the whole point of a project launcher that does not need the
  // main window open — closing it must not take the process (and the icon) down too.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  // Standard pairing for the above: without this, clicking the Dock icon after the
  // window was closed does nothing, since nothing tells AppKit to bring it back.
  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag {
      NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
