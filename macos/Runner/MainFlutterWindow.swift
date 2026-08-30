import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // The app no longer quits when this closes (menu bar icon needs it to survive),
    // so the window itself must survive too — otherwise there is nothing left for
    // "Open Loom" or a Dock click to bring back.
    self.isReleasedWhenClosed = false

    // Registers workspace_flow_system too, which brings up the method channel.
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
