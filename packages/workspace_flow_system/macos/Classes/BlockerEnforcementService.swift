import Cocoa

/// Enforces a blocker profile.
///
/// Not implemented yet — v1 ships the Dart-side fake. The intended approach is:
/// apps are polled through `NSWorkspace.runningApplications` and hidden or terminated
/// when they match the armed profile; domains are written into `/etc/hosts` by a
/// privileged helper the user approves once. The method channel already routes here so
/// only this file changes when the enforcement lands.
enum BlockerEnforcementService {
  private(set) static var armedItems: [[String: Any]] = []

  static func arm(items: [[String: Any]]) {
    armedItems = items
  }

  static func disarm() {
    armedItems = []
  }
}
