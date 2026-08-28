import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/captured_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

part 'window_capture.service.g.dart';

/// Turns the windows that are open right now into a project layout.
///
/// Arranging the real windows by hand and freezing that state is usually far quicker
/// than rebuilding the same layout tile by tile in the editor.
@Riverpod(keepAlive: true)
class WindowCaptureService extends _$WindowCaptureService {
  @override
  void build() {}

  /// Reads the open windows and maps them onto the attached screens.
  ///
  /// Returns an empty list when accessibility permission is missing or the bridge is
  /// unavailable — the caller shows the permission hint rather than an empty layout.
  Future<List<ProjectWindow>> capture() async {
    final List<CapturedWindow> captured;
    try {
      captured = await ref.read(windowControlRepositoryProvider).captureWindows();
    } on Object {
      return const [];
    }

    final screens = await ref.read(screensProvider.future);
    if (screens.isEmpty) return const [];

    return [for (final (index, window) in captured.indexed) ..._toLayout(window, index, screens)];
  }

  /// One captured window becomes one tile, on the screen it mostly sits on.
  Iterable<ProjectWindow> _toLayout(CapturedWindow window, int index, List<ScreenInfo> screens) sync* {
    final screen = _screenFor(window, screens);
    if (screen == null) return;

    final percent = screen.percentFromRect(x: window.x, y: window.y, width: window.width, height: window.height);

    yield ProjectWindow(
      // Negative, like every other draft tile, so it cannot collide with a stored row.
      id: -(index + 1),
      name: window.name,
      bundleId: window.bundleId,
      screenIndex: screen.index,
      x: percent.x,
      y: percent.y,
      width: percent.width,
      height: percent.height,
      sortOrder: index,
    );
  }

  /// The display the window covers the most; windows straddling two screens go to the
  /// one holding the larger part of them.
  ScreenInfo? _screenFor(CapturedWindow window, List<ScreenInfo> screens) {
    ScreenInfo? best;
    var bestArea = 0.0;

    for (final screen in screens) {
      final area = screen.overlapArea(x: window.x, y: window.y, width: window.width, height: window.height);
      if (area > bestArea) {
        bestArea = area;
        best = screen;
      }
    }

    return best;
  }
}
