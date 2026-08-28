import Cocoa

/// The menu-bar item showing the running session's countdown.
final class StatusItemService {
  static let shared = StatusItemService()

  private var statusItem: NSStatusItem?
  private var onClick: (() -> Void)?

  private init() {}

  func configure(onClick: @escaping () -> Void) {
    self.onClick = onClick
  }

  /// Passing nil removes the item — no session, no menu bar clutter.
  func setTitle(_ title: String?) {
    guard let title else {
      if let statusItem {
        NSStatusBar.system.removeStatusItem(statusItem)
      }
      statusItem = nil
      return
    }

    let item = statusItem ?? NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusItem = item

    item.button?.title = title
    item.button?.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
    item.button?.target = self
    item.button?.action = #selector(handleClick)
  }

  @objc private func handleClick() {
    onClick?()
  }
}
