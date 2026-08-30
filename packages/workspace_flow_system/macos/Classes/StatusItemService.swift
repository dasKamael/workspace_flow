import Cocoa

/// The menu bar's icon — a project launcher, a blocker-profile switch, and a
/// focus-session toggle that all work whether or not the main window is open, plus the
/// running session's countdown alongside it.
///
/// Unlike the icon this replaces (which existed only while a session was running), the
/// item itself is now permanent once configured; only the countdown text comes and goes.
final class StatusItemService {
  static let shared = StatusItemService()

  /// The quick-start lengths next to "Start Focus" — mirrors `FocusPreset.all` in Dart
  /// minus the open-end preset, which has no number to show as a button.
  private static let quickStartMinutes = [25, 50, 90]

  private var statusItem: NSStatusItem?
  private var onOpen: (() -> Void)?
  private var onLaunchProject: ((Int) -> Void)?
  private var onToggleFocus: (() -> Void)?
  private var onStartFocus: ((Int) -> Void)?
  private var onArmProfile: ((Int) -> Void)?
  private var onDisarmProfile: (() -> Void)?
  private var projects: [(id: Int, name: String)] = []
  private var blockerProfiles: [(id: Int, name: String)] = []
  private var isSessionRunning = false
  private var armedProfileName: String?

  private init() {}

  func configure(
    onOpen: @escaping () -> Void,
    onLaunchProject: @escaping (Int) -> Void,
    onToggleFocus: @escaping () -> Void,
    onStartFocus: @escaping (Int) -> Void,
    onArmProfile: @escaping (Int) -> Void,
    onDisarmProfile: @escaping () -> Void
  ) {
    self.onOpen = onOpen
    self.onLaunchProject = onLaunchProject
    self.onToggleFocus = onToggleFocus
    self.onStartFocus = onStartFocus
    self.onArmProfile = onArmProfile
    self.onDisarmProfile = onDisarmProfile
    createItemIfNeeded()
  }

  /// The running session's countdown, shown as text next to the icon. `nil` clears it —
  /// the icon and its menu stay either way.
  func setTitle(_ title: String?) {
    createItemIfNeeded()
    statusItem?.button?.title = title ?? ""
  }

  /// Whether the focus row shows "Start Focus" plus quick-start lengths, or just "Stop
  /// Focus" — starting a specific length while one is already running would be
  /// ambiguous, so the quick-start buttons only make sense while idle.
  func setSessionRunning(_ isRunning: Bool) {
    isSessionRunning = isRunning
    rebuildMenu()
  }

  /// Rebuilds the project list in the dropdown.
  func setProjects(_ projects: [(id: Int, name: String)]) {
    self.projects = projects
    rebuildMenu()
  }

  /// Rebuilds the blocker profile list in the dropdown.
  func setBlockerProfiles(_ profiles: [(id: Int, name: String)]) {
    blockerProfiles = profiles
    rebuildMenu()
  }

  /// `nil` shows every profile so one can be armed; a name shows "Stop <name>" instead —
  /// picking a different profile while one is already armed would be ambiguous, so the
  /// list only makes sense while idle (same reasoning as the focus quick-start row).
  func setArmedProfile(_ name: String?) {
    armedProfileName = name
    rebuildMenu()
  }

  private func createItemIfNeeded() {
    guard statusItem == nil else { return }

    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let icon = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: "Loom")
    icon?.isTemplate = true
    item.button?.image = icon
    item.button?.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
    statusItem = item
    rebuildMenu()
  }

  /// A native section header on macOS 14+ (small-caps, matches Control Center); a
  /// plain disabled row on 13, where `NSMenuItem.sectionHeader` does not exist yet.
  private func sectionHeader(_ title: String) -> NSMenuItem {
    if #available(macOS 14.0, *) {
      return NSMenuItem.sectionHeader(title: title)
    }
    let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
    item.isEnabled = false
    return item
  }

  private func rebuildMenu() {
    guard let statusItem else { return }
    let menu = NSMenu()

    menu.addItem(sectionHeader("Projects"))
    if projects.isEmpty {
      let empty = NSMenuItem(title: "No projects yet", action: nil, keyEquivalent: "")
      empty.isEnabled = false
      menu.addItem(empty)
    } else {
      for project in projects {
        let item = NSMenuItem(title: project.name, action: #selector(handleLaunchProject(_:)), keyEquivalent: "")
        item.target = self
        item.representedObject = project.id
        menu.addItem(item)
      }
    }

    menu.addItem(.separator())
    menu.addItem(sectionHeader("Blocker"))

    if let armedProfileName {
      // Mirrors "Stop Focus" below rather than the domain's own "arm/disarm" jargon —
      // that naming is fine for the code, not for what the user reads in the menu.
      let stop = NSMenuItem(title: "Stop \(armedProfileName)", action: #selector(handleDisarmProfile), keyEquivalent: "")
      stop.target = self
      menu.addItem(stop)
    } else if blockerProfiles.isEmpty {
      let empty = NSMenuItem(title: "No blocker profiles yet", action: nil, keyEquivalent: "")
      empty.isEnabled = false
      menu.addItem(empty)
    } else {
      // Plain name, same as the projects list above it — clicking it is the action,
      // the same way clicking a project launches it.
      for profile in blockerProfiles {
        let item = NSMenuItem(title: profile.name, action: #selector(handleArmProfile(_:)), keyEquivalent: "")
        item.target = self
        item.representedObject = profile.id
        menu.addItem(item)
      }
    }

    menu.addItem(.separator())
    menu.addItem(sectionHeader("Focus"))

    if isSessionRunning {
      let stop = NSMenuItem(title: "Stop Focus", action: #selector(handleToggleFocus), keyEquivalent: "")
      stop.target = self
      menu.addItem(stop)
    } else {
      let quickStart = NSMenuItem()
      // A bare `NSMenuItem()` — no title/action of its own — renders its custom view
      // dimmed by default, even though the buttons inside have real targets/actions.
      quickStart.isEnabled = true
      quickStart.view = makeQuickStartRow()
      menu.addItem(quickStart)
    }

    menu.addItem(.separator())

    let open = NSMenuItem(title: "Open Loom", action: #selector(handleOpen), keyEquivalent: "")
    open.target = self
    menu.addItem(open)

    menu.addItem(.separator())

    let quit = NSMenuItem(title: "Quit Loom", action: #selector(handleQuit), keyEquivalent: "")
    quit.target = self
    menu.addItem(quit)

    // Assigning a menu makes AppKit pop it on click by itself — no button target/action
    // of our own needed for that part.
    statusItem.menu = menu
  }

  /// A quick-start button per length, side by side in one row — a custom view is the
  /// only way to lay out more than one control in a single menu row. No separate
  /// "Start Focus" button: the "Focus" header above already says what these do, and a
  /// length is always needed to start one anyway.
  private func makeQuickStartRow() -> NSView {
    let durationButtons = Self.quickStartMinutes.map { minutes -> NSButton in
      let button = NSButton(title: "\(minutes)", target: self, action: #selector(handleStartFocusDuration(_:)))
      button.tag = minutes
      button.isEnabled = true
      button.bezelStyle = .inline
      button.controlSize = .small
      button.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .regular)
      return button
    }

    let stack = NSStackView(views: durationButtons)
    stack.orientation = .horizontal
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false

    let container = NSView(frame: NSRect(x: 0, y: 0, width: 230, height: 26))
    container.addSubview(stack)
    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -14),
      stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
    ])
    return container
  }

  @objc private func handleLaunchProject(_ sender: NSMenuItem) {
    guard let projectId = sender.representedObject as? Int else { return }
    onLaunchProject?(projectId)
  }

  @objc private func handleArmProfile(_ sender: NSMenuItem) {
    guard let profileId = sender.representedObject as? Int else { return }
    onArmProfile?(profileId)
  }

  @objc private func handleDisarmProfile() {
    onDisarmProfile?()
  }

  @objc private func handleToggleFocus() {
    onToggleFocus?()
  }

  @objc private func handleStartFocusDuration(_ sender: NSButton) {
    onStartFocus?(sender.tag)
  }

  @objc private func handleOpen() {
    onOpen?()
  }

  @objc private func handleQuit() {
    NSApp.terminate(nil)
  }
}
