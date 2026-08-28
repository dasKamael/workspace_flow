import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/project/model/window_snap.dart';

/// Geometry for dragging and resizing window tiles.
///
/// Movement is continuous — the tile follows the pointer exactly. Magnetism only kicks
/// in once an edge comes within [magnetThreshold] of a magnet, and lets go again as
/// soon as the pointer moves further, which is why every call takes the *raw* target
/// derived from the drag origin rather than the previously written value.
class WindowSnapUtil {
  WindowSnapUtil._();

  /// How close an edge has to be, in percent, before a magnet catches it.
  static const double magnetThreshold = 1.5;

  /// Moves [moving] to the raw position ([x], [y]), snapping edges that come close to
  /// a screen edge, the screen centre, or an edge or centre line of a neighbour.
  static WindowSnap snapMove({
    required ProjectWindow moving,
    required List<ProjectWindow> neighbours,
    required double x,
    required double y,
    required bool magnetsEnabled,
  }) {
    final width = moving.width;
    final height = moving.height;
    final rawX = _clampPosition(x, width);
    final rawY = _clampPosition(y, height);

    if (!magnetsEnabled) {
      return WindowSnap(x: rawX, y: rawY, width: width, height: height);
    }

    final same = _sameScreen(moving, neighbours);
    final horizontal = _snapAxis(position: rawX, size: width, magnets: _magnetsX(same));
    final vertical = _snapAxis(position: rawY, size: height, magnets: _magnetsY(same));

    return WindowSnap(
      x: horizontal.position,
      y: vertical.position,
      width: width,
      height: height,
      guidesX: horizontal.guides,
      guidesY: vertical.guides,
    );
  }

  /// Resizes [window] by dragging [handle] by ([deltaX], [deltaY]).
  ///
  /// [window] is the rectangle the drag *started* from, and the deltas are cumulative,
  /// so the result never drifts. Only the edges the handle actually moves are snapped
  /// and clamped; the opposite edge stays exactly where it is.
  static WindowSnap snapResize({
    required ProjectWindow window,
    required ResizeHandle handle,
    required double deltaX,
    required double deltaY,
    required List<ProjectWindow> neighbours,
    required bool magnetsEnabled,
  }) {
    var left = window.x;
    var right = window.x + window.width;
    var top = window.y;
    var bottom = window.y + window.height;

    if (handle.movesLeftEdge) left += deltaX;
    if (handle.movesRightEdge) right += deltaX;
    if (handle.movesTopEdge) top += deltaY;
    if (handle.movesBottomEdge) bottom += deltaY;

    final same = _sameScreen(window, neighbours);
    final magnetsX = magnetsEnabled ? _magnetsX(same) : const <double>[];
    final magnetsY = magnetsEnabled ? _magnetsY(same) : const <double>[];

    // Only the edges this handle owns are magnetic; the opposite edge must not drift.
    if (handle.movesLeftEdge) left = _nearestMagnet(left, magnetsX) ?? left;
    if (handle.movesRightEdge) right = _nearestMagnet(right, magnetsX) ?? right;
    if (handle.movesTopEdge) top = _nearestMagnet(top, magnetsY) ?? top;
    if (handle.movesBottomEdge) bottom = _nearestMagnet(bottom, magnetsY) ?? bottom;

    // Clamped so the moving edge never crosses the fixed one or leaves the monitor.
    if (handle.movesLeftEdge) left = left.clamp(0.0, right - ProjectWindow.minSize);
    if (handle.movesRightEdge) right = right.clamp(left + ProjectWindow.minSize, 100.0);
    if (handle.movesTopEdge) top = top.clamp(0.0, bottom - ProjectWindow.minSize);
    if (handle.movesBottomEdge) bottom = bottom.clamp(top + ProjectWindow.minSize, 100.0);

    // Read the guides off the settled rectangle, so an edge that was clamped away from
    // its magnet silently loses its guide.
    return WindowSnap(
      x: left,
      y: top,
      width: right - left,
      height: bottom - top,
      guidesX: _guidesAt([if (handle.movesLeftEdge) left, if (handle.movesRightEdge) right], magnetsX),
      guidesY: _guidesAt([if (handle.movesTopEdge) top, if (handle.movesBottomEdge) bottom], magnetsY),
    );
  }

  /// Only tiles on the same monitor can act as magnets, and a tile never snaps to itself.
  static List<ProjectWindow> _sameScreen(ProjectWindow window, List<ProjectWindow> neighbours) => neighbours
      .where((neighbour) => neighbour.screenIndex == window.screenIndex && neighbour.id != window.id)
      .toList();

  /// Screen edges, screen centre, and every neighbour's edges and centre line.
  static List<double> _magnetsX(List<ProjectWindow> neighbours) => [
    0,
    50,
    100,
    for (final neighbour in neighbours) ...[
      neighbour.x,
      neighbour.x + neighbour.width,
      neighbour.x + neighbour.width / 2,
    ],
  ];

  static List<double> _magnetsY(List<ProjectWindow> neighbours) => [
    0,
    50,
    100,
    for (final neighbour in neighbours) ...[
      neighbour.y,
      neighbour.y + neighbour.height,
      neighbour.y + neighbour.height / 2,
    ],
  ];

  /// Snaps a whole edge-triple — leading edge, trailing edge and centre — moving the
  /// rectangle as one. The closest of all candidates wins.
  static ({double position, List<double> guides}) _snapAxis({
    required double position,
    required double size,
    required List<double> magnets,
  }) {
    // Each edge as its offset from the tile's leading edge, so the snapped position can
    // be derived straight from the magnet. Adding a delta instead would leave the edge
    // a floating-point hair off the magnet, and two tiles would not read as flush.
    final edgeOffsets = [0.0, size, size / 2];

    double? bestMagnet;
    var bestEdgeOffset = 0.0;
    var bestDistance = magnetThreshold;

    for (final edgeOffset in edgeOffsets) {
      for (final magnet in magnets) {
        final distance = (magnet - (position + edgeOffset)).abs();
        if (distance < bestDistance) {
          bestDistance = distance;
          bestEdgeOffset = edgeOffset;
          bestMagnet = magnet;
        }
      }
    }

    if (bestMagnet == null) return (position: position, guides: const []);

    // Snapping must not push the tile off the monitor; if it would, it does not apply.
    final snapped = bestMagnet - bestEdgeOffset;
    if (snapped != _clampPosition(snapped, size)) return (position: position, guides: const []);

    // Every magnet the settled rectangle actually touches, not just the one that won
    // the race — a tile wedged between a neighbour and the screen edge sits on both,
    // and drawing only one of them would look arbitrary.
    return (position: snapped, guides: _guidesAt([snapped, snapped + size, snapped + size / 2], magnets));
  }

  /// The magnets that coincide with one of [edges], deduplicated and in order.
  static List<double> _guidesAt(List<double> edges, List<double> magnets) {
    final guides = <double>{};

    for (final magnet in magnets) {
      for (final edge in edges) {
        if ((magnet - edge).abs() < _epsilon) guides.add(magnet);
      }
    }

    return guides.toList()..sort();
  }

  /// Tolerance for "this edge sits on that magnet" after the arithmetic above.
  static const double _epsilon = 0.0001;

  /// The nearest magnet to a single edge, or null when none is close enough.
  static double? _nearestMagnet(double edge, List<double> magnets) {
    double? best;
    var bestDistance = magnetThreshold;

    for (final magnet in magnets) {
      final distance = (magnet - edge).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        best = magnet;
      }
    }

    return best;
  }

  /// Keeps a tile of [size] fully inside its monitor.
  static double _clampPosition(double value, double size) => value.clamp(0, (100 - size).clamp(0, 100));
}
