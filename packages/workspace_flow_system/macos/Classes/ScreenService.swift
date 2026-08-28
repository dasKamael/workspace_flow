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
      if let inches = diagonalInches(of: screen) {
        entry["diagonalInches"] = inches
      }
      return entry
    }
  }

  /// Physical diagonal in inches, for the "Monitor 1 · 27″" caption.
  private static func diagonalInches(of screen: NSScreen) -> Double? {
    guard
      let number = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber
    else { return nil }

    let size = CGDisplayScreenSize(CGDirectDisplayID(number.uint32Value))
    guard size.width > 0, size.height > 0 else { return nil }

    let millimetres = (size.width * size.width + size.height * size.height).squareRoot()
    return millimetres / 25.4
  }
}
