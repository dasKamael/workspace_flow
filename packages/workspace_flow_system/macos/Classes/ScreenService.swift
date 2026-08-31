import Cocoa

/// Reads the attached displays.
///
/// `visibleFrame` excludes the menu bar and the Dock — it is the rectangle a project's
/// percentage coordinates map onto. Note the flip: AppKit's origin is bottom-left, the
/// app works top-left, so `visibleY` is converted here once and never again.
enum ScreenService {
  static func screens() -> [[String: Any]] {
    let displays = NSScreen.screens
    guard let primary = displays.first else { return [] }

    return displays.map { screen in
      let frame = screen.visibleFrame
      // Flip into a top-left origin space spanning the primary screen.
      let topLeftY = primary.frame.maxY - frame.maxY

      var entry: [String: Any] = [
        "visibleX": frame.origin.x,
        "visibleY": topLeftY,
        "visibleWidth": frame.width,
        "visibleHeight": frame.height,
        "isMain": screen == NSScreen.main,
      ]
      if let id = displayId(of: screen) {
        // Stable across sleep/wake and reconnects for the same physical display —
        // unlike array position, which `NSScreen.screens` does not guarantee to keep,
        // so a saved layout can otherwise land on the wrong monitor after either.
        entry["displayId"] = Int(id)
        let size = CGDisplayScreenSize(id)
        if size.width > 0, size.height > 0 {
          let millimetres = (size.width * size.width + size.height * size.height).squareRoot()
          entry["diagonalInches"] = millimetres / 25.4
        }
      }
      return entry
    }
  }

  private static func displayId(of screen: NSScreen) -> CGDirectDisplayID? {
    guard
      let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber
    else { return nil }
    return CGDirectDisplayID(number.uint32Value)
  }
}
