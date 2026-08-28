/// The macOS system bridge.
///
/// The plugin has no Dart API of its own: it registers a method-channel handler on
/// [systemChannelName], and the app talks to it through
/// `data/system/data_source/macos_bridge.channel.dart`. Keeping the Swift code in a
/// plugin package means CocoaPods picks up every file in `macos/Classes/` — no manual
/// `project.pbxproj` bookkeeping when a service is added.
library;

/// The channel the app and the plugin agree on.
const String systemChannelName = 'de.coodoo.workspace_flow/system';

/// The channel the blocked-page window is fed through.
const String blockedPageChannelName = 'de.coodoo.workspace_flow/blocked_page';
