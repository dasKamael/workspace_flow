import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_progress.freezed.dart';

/// How far one window of a project has got while launching.
enum LaunchStep {
  /// Nothing has happened yet — the row shows "—".
  pending,

  /// The app is starting and its window is being placed.
  opening,

  /// The window is open and positioned.
  open,

  /// The app started but its window could not be positioned.
  failed,
}

/// Progress of a launch run, one entry per window of the project.
@freezed
abstract class LaunchProgress with _$LaunchProgress {
  const factory LaunchProgress({
    @Default({}) Map<int, LaunchStep> steps,
    @Default(false) bool isLaunching,

    /// True once every window has been dealt with — the button reads "Re-arrange".
    @Default(false) bool hasLaunched,

    /// Set when the accessibility permission is missing.
    @Default(false) bool needsAccessibilityPermission,
  }) = _LaunchProgress;

  const LaunchProgress._();

  LaunchStep stepFor(int windowId) => steps[windowId] ?? LaunchStep.pending;
}
