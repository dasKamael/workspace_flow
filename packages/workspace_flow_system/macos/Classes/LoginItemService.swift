import Foundation
import ServiceManagement

/// Registers the app to start at login.
enum LoginItemService {
  static func isEnabled() -> Bool {
    SMAppService.mainApp.status == .enabled
  }

  static func setEnabled(_ enabled: Bool) throws {
    if enabled {
      try SMAppService.mainApp.register()
    } else {
      try SMAppService.mainApp.unregister()
    }
  }
}
