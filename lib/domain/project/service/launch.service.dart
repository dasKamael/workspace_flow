import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';
import 'package:workspace_flow/domain/project/model/launch_progress.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

part 'launch.service.g.dart';

/// Opens a project's apps and puts their windows back where they were saved.
///
/// Each window really is launched and positioned; the design's 520ms cascade is a
/// minimum dwell time on top of that, so a fast launch still reads as a sequence
/// instead of flashing every row to "open" at once.
@Riverpod(keepAlive: true)
class LaunchService extends _$LaunchService {
  /// Minimum time a row stays in the "opening…" state.
  static const Duration minimumStepDuration = Duration(milliseconds: 520);

  @override
  LaunchProgress build() => const LaunchProgress();

  /// Resets the progress — called when a different project is selected.
  void reset() => state = const LaunchProgress();

  /// Launches every window of [project], one after another.
  Future<void> launch(Project project) async {
    if (state.isLaunching) return;

    final launcher = ref.read(appLauncherRepositoryProvider);
    final windowControl = ref.read(windowControlRepositoryProvider);
    // Refreshed rather than read: `screensProvider` is keepAlive and a display could
    // have been connected or disconnected since it was last resolved.
    final screens = await ref.refresh(screensProvider.future);
    final canPosition = await _isAccessibilityTrusted(windowControl);

    state = LaunchProgress(
      isLaunching: true,
      needsAccessibilityPermission: !canPosition,
      steps: {for (final window in project.windows) window.id: LaunchStep.pending},
    );

    for (final window in project.windows) {
      _setStep(window.id, LaunchStep.opening);
      final startedAt = DateTime.now();

      final succeeded = await _open(
        window: window,
        screens: screens,
        launcher: launcher,
        windowControl: windowControl,
        canPosition: canPosition,
      );

      // Hold the "opening…" state long enough for the row animation to read.
      final remaining = minimumStepDuration - DateTime.now().difference(startedAt);
      if (remaining > Duration.zero) await Future<void>.delayed(remaining);

      _setStep(window.id, succeeded ? LaunchStep.open : LaunchStep.failed);
    }

    state = state.copyWith(isLaunching: false, hasLaunched: true);
  }

  Future<bool> _open({
    required ProjectWindow window,
    required List<ScreenInfo> screens,
    required AppLauncherRepository launcher,
    required WindowControlRepository windowControl,
    required bool canPosition,
  }) async {
    try {
      if (window.isWebsite) {
        await launcher.openUrl(window.url!);
        // A browser tab has no window of its own to place.
        return true;
      }

      final bundleId = window.bundleId;
      if (bundleId == null) return false;

      // A window naming a project folder opens that folder, not just the app blank —
      // and, unlike a plain launch, always opens a fresh window even if the app is
      // already running with other projects open.
      final processId = window.documentPath != null
          ? await launcher.launchWithDocument(bundleId: bundleId, documentPath: window.documentPath!)
          : await launcher.launchApp(bundleId: bundleId);
      if (processId == null) return false;
      if (!canPosition) return true;

      final screen = _screenFor(window.screenIndex, screens);
      if (screen == null) return true;

      final rect = screen.rectFromPercent(x: window.x, y: window.y, width: window.width, height: window.height);
      return windowControl.positionWindow(
        processId: processId,
        x: rect.x,
        y: rect.y,
        width: rect.width,
        height: rect.height,
      );
    } on Object {
      return false;
    }
  }

  /// The saved screen, or the main screen when that display is no longer attached.
  ScreenInfo? _screenFor(int index, List<ScreenInfo> screens) {
    if (screens.isEmpty) return null;
    if (index >= 0 && index < screens.length) return screens[index];
    return screens.firstWhere((screen) => screen.isMain, orElse: () => screens.first);
  }

  Future<bool> _isAccessibilityTrusted(WindowControlRepository windowControl) async {
    try {
      return await windowControl.isAccessibilityTrusted();
    } on Object {
      return false;
    }
  }

  void _setStep(int windowId, LaunchStep step) => state = state.copyWith(steps: {...state.steps, windowId: step});
}
