import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Registers workspace_flow_system too, which brings up the method channel.
    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
