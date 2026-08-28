import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';

/// What a running drag or resize needs to remember.
///
/// [origin] is the tile as it was when the drag started. Every update is computed from
/// it plus the total pointer travel — never from the value written in the meantime,
/// which is what lets a tile follow the pointer exactly and leave a magnet again
/// instead of sticking to it.
class WindowDragSession {
  const WindowDragSession({required this.index, required this.origin, required this.pointerStart, this.handle});

  final int index;
  final ProjectWindow origin;
  final Offset pointerStart;

  /// Null while moving the whole tile.
  final ResizeHandle? handle;

  bool get isResize => handle != null;
}

/// The pointer bookkeeping shared by every surface that arranges window tiles.
///
/// Two surfaces do this: the miniature monitor stage in the editor sheet, and the
/// full-size overlay on the real screens. They differ only in geometry — how big a
/// monitor is on screen and where it sits — so that part stays with each surface while
/// the session handling lives here.
mixin WindowDragHandling<T extends StatefulWidget> on State<T> {
  WindowDragSession? _session;

  WindowDragSession? get session => _session;

  // --------------------------------------------------------------- geometry
  /// Size in logical pixels of the monitor with [screenIndex], to turn pointer travel
  /// into percentages of that display.
  Size? monitorSizeOf(int screenIndex);

  /// The monitor under [globalPosition], or null when the pointer is outside all of
  /// them — which is how a tile gets removed by dropping it away from the surface.
  int? monitorAt(Offset globalPosition);

  /// The tile at [index] of the current draft.
  ProjectWindow? windowAt(int index);

  // --------------------------------------------------------------- reporting
  void reportMove({
    required int index,
    required int screenIndex,
    required double x,
    required double y,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  });

  void reportResize({
    required int index,
    required ResizeHandle handle,
    required double deltaX,
    required double deltaY,
    required ProjectWindow origin,
    required bool magnetsEnabled,
  });

  void reportDragEnd();

  void reportRemove(int index);

  // ---------------------------------------------------------------- gestures
  /// Holding option suspends magnetism for fine positioning.
  bool get magnetsEnabled => !HardwareKeyboard.instance.isAltPressed;

  void startDrag(int index, Offset globalPosition, {ResizeHandle? handle}) {
    final window = windowAt(index);
    if (window == null) return;
    _session = WindowDragSession(index: index, origin: window, pointerStart: globalPosition, handle: handle);
  }

  void updateMove(Offset globalPosition) {
    final session = _session;
    if (session == null || session.isResize) return;

    // The monitor under the pointer wins, so a tile can cross displays mid-drag.
    final target = monitorAt(globalPosition) ?? session.origin.screenIndex;
    final size = monitorSizeOf(target);
    if (size == null) return;

    final travel = globalPosition - session.pointerStart;
    reportMove(
      index: session.index,
      screenIndex: target,
      x: session.origin.x + travel.dx / size.width * 100,
      y: session.origin.y + travel.dy / size.height * 100,
      origin: session.origin,
      magnetsEnabled: magnetsEnabled,
    );
  }

  void updateResize(Offset globalPosition) {
    final session = _session;
    final handle = session?.handle;
    if (session == null || handle == null) return;

    final size = monitorSizeOf(session.origin.screenIndex);
    if (size == null) return;

    final travel = globalPosition - session.pointerStart;
    reportResize(
      index: session.index,
      handle: handle,
      deltaX: travel.dx / size.width * 100,
      deltaY: travel.dy / size.height * 100,
      origin: session.origin,
      magnetsEnabled: magnetsEnabled,
    );
  }

  /// Ends a drag. [globalPosition] is null for a resize, which can never remove a tile.
  void endDrag(Offset? globalPosition) {
    final session = _session;
    _session = null;
    reportDragEnd();

    // Dropped away from every monitor — that removes the tile.
    if (session != null && !session.isResize && globalPosition != null && monitorAt(globalPosition) == null) {
      reportRemove(session.index);
    }
  }
}
