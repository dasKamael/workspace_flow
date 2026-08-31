import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/project/window_snap.util.dart';

/// Dragging is continuous; magnets only catch an edge that comes close, and let go
/// again as soon as the pointer moves on.
void main() {
  ProjectWindow window({
    int id = 1,
    int screenIndex = 0,
    double x = 20,
    double y = 20,
    double width = 30,
    double height = 30,
  }) => ProjectWindow(id: id, name: 'VS Code', screenIndex: screenIndex, x: x, y: y, width: width, height: height);

  group('moving', () {
    test('Given a neighbour on a different screen sitting exactly where a magnet '
        'would catch, '
        'when a tile is moved near that same spot, '
        'then it is not treated as a magnet — screens never share snap neighbours, '
        'even when the caller passes every window instead of pre-filtering', () {
      // Given — this is the scenario the multi-window overlay relies on: every
      // screen's widget now passes the *whole* draft layout as `neighbours`, not
      // just its own screen's slice, because filtering already happens in here.
      final elsewhere = window(id: 2, screenIndex: 1, x: 40, y: 40, width: 30, height: 30);

      // When — 40.8 would snap to 40 (elsewhere's left edge) if screens leaked in
      final snap = WindowSnapUtil.snapMove(
        moving: window(screenIndex: 0),
        neighbours: [elsewhere],
        x: 40.8,
        y: 41.3,
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 40.8);
      expect(snap.hasGuides, isFalse);
    });

    test('Given a tile dragged far from anything, '
        'when it is moved, '
        'then it lands exactly where the pointer put it', () {
      // Given / When — 23.7 is not near any magnet
      final snap = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: const [],
        x: 23.7,
        y: 41.3,
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 23.7);
      expect(snap.y, 41.3);
      expect(snap.hasGuides, isFalse);
    });

    test('Given a tile dragged close to the left edge, '
        'when it is moved, '
        'then its leading edge snaps flush to zero and reports a guide', () {
      // Given / When
      final snap = WindowSnapUtil.snapMove(moving: window(), neighbours: const [], x: 0.8, y: 40, magnetsEnabled: true);

      // Then
      expect(snap.x, 0);
      expect(snap.guidesX, [0]);
    });

    test('Given a 30% wide tile dragged near the screen centre, '
        'when it is moved, '
        'then its centre line snaps to 50', () {
      // Given / When — centred would be x = 35
      final snap = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: const [],
        x: 34.2,
        y: 40,
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 35);
      expect(snap.guidesX, [50]);
    });

    test('Given a neighbour ending at 62.5, '
        'when a tile is dragged just past it, '
        'then it lands flush against that edge', () {
      // Given
      final neighbour = window(id: 2, x: 0, y: 0, width: 62.5, height: 100);

      // When — dropped a hair short of the neighbour's right edge
      final snap = WindowSnapUtil.snapMove(
        moving: window(id: 1, width: 37.5, height: 100),
        neighbours: [neighbour],
        x: 61.9,
        y: 0,
        magnetsEnabled: true,
      );

      // Then — the two tiles now tile the screen without a gap
      expect(snap.x, 62.5);
      expect(snap.x + 37.5, 100);
      // Wedged between the neighbour and the right edge, so both magnets are drawn
      expect(snap.guidesX, [62.5, 100]);
    });

    test('Given a tile sitting on a magnet, '
        'when the pointer keeps going past the threshold, '
        'then it lets go instead of sticking', () {
      // Given — snapped to the left edge
      final snapped = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: const [],
        x: 0.8,
        y: 40,
        magnetsEnabled: true,
      );
      expect(snapped.x, 0);

      // When — the raw target keeps moving; the call always starts from the origin
      final released = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: const [],
        x: 4,
        y: 40,
        magnetsEnabled: true,
      );

      // Then
      expect(released.x, 4);
      expect(released.hasGuides, isFalse);
    });

    test('Given magnets are switched off, '
        'when a tile is dragged right onto an edge, '
        'then nothing snaps', () {
      // Given / When
      final snap = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: const [],
        x: 0.4,
        y: 40,
        magnetsEnabled: false,
      );

      // Then
      expect(snap.x, 0.4);
      expect(snap.hasGuides, isFalse);
    });

    test('Given a neighbour on another monitor, '
        'when a tile is dragged near its edge, '
        'then that neighbour does not act as a magnet', () {
      // Given
      final elsewhere = window(id: 2, screenIndex: 1, x: 62.5, width: 37.5);

      // When
      final snap = WindowSnapUtil.snapMove(
        moving: window(),
        neighbours: [elsewhere],
        x: 61.9,
        y: 40,
        magnetsEnabled: true,
      );

      // Then — 61.9 is not near 0, 50 or 100 either, so it stays put
      expect(snap.x, 61.9);
      expect(snap.hasGuides, isFalse);
    });

    test('Given a tile dragged past the right edge of the monitor, '
        'when it is moved, '
        'then it stops at the edge instead of leaving the screen', () {
      // Given / When
      final snap = WindowSnapUtil.snapMove(
        moving: window(width: 30),
        neighbours: const [],
        x: 140,
        y: 40,
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 70);
      expect(snap.x + snap.width, 100);
    });
  });

  group('resizing', () {
    test('Given the right handle, '
        'when it is dragged outwards, '
        'then only the width grows and the left edge stays put', () {
      // Given / When
      final snap = WindowSnapUtil.snapResize(
        window: window(x: 20, width: 30),
        handle: ResizeHandle.right,
        deltaX: 7.3,
        deltaY: 0,
        neighbours: const [],
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 20);
      expect(snap.width, 37.3);
    });

    test('Given the left handle, '
        'when it is dragged outwards, '
        'then the tile grows to the left without moving its right edge', () {
      // Given
      final origin = window(x: 20, width: 30);

      // When
      final snap = WindowSnapUtil.snapResize(
        window: origin,
        handle: ResizeHandle.left,
        deltaX: -8.4,
        deltaY: 0,
        neighbours: const [],
        magnetsEnabled: true,
      );

      // Then — this is what the single bottom-right grip could never do
      expect(snap.x, closeTo(11.6, 0.001));
      expect(snap.width, closeTo(38.4, 0.001));
      expect(snap.x + snap.width, closeTo(50, 0.001));
    });

    test('Given the top-left corner, '
        'when it is dragged, '
        'then both the left and the top edge move', () {
      // Given / When
      final snap = WindowSnapUtil.snapResize(
        window: window(x: 20, y: 20, width: 30, height: 30),
        handle: ResizeHandle.topLeft,
        deltaX: -5,
        deltaY: -4,
        neighbours: const [],
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 15);
      expect(snap.y, 16);
      expect(snap.width, 35);
      expect(snap.height, 34);
    });

    test('Given a resize that would shrink a tile below the minimum, '
        'when the handle is dragged, '
        'then it stops at 15% and the fixed edge does not move', () {
      // Given
      final origin = window(x: 20, width: 30);

      // When — dragging the left edge far to the right
      final snap = WindowSnapUtil.snapResize(
        window: origin,
        handle: ResizeHandle.left,
        deltaX: 40,
        deltaY: 0,
        neighbours: const [],
        magnetsEnabled: true,
      );

      // Then
      expect(snap.width, ProjectWindow.minSize);
      expect(snap.x + snap.width, 50, reason: 'the right edge must stay where it was');
    });

    test('Given a resize dragged past the monitor edge, '
        'when the handle is released, '
        'then the edge stops at 100 and the opposite edge is untouched', () {
      // Given / When
      final snap = WindowSnapUtil.snapResize(
        window: window(x: 20, width: 30),
        handle: ResizeHandle.right,
        deltaX: 90,
        deltaY: 0,
        neighbours: const [],
        magnetsEnabled: true,
      );

      // Then
      expect(snap.x, 20);
      expect(snap.x + snap.width, 100);
    });

    test('Given a neighbour whose left edge sits at 62.5, '
        'when a tile is resized to just under it, '
        'then the moving edge snaps flush and reports the guide', () {
      // Given
      final neighbour = window(id: 2, x: 62.5, y: 0, width: 37.5, height: 100);

      // When — right edge dragged from 50 to 61.8
      final snap = WindowSnapUtil.snapResize(
        window: window(id: 1, x: 0, y: 0, width: 50, height: 100),
        handle: ResizeHandle.right,
        deltaX: 11.8,
        deltaY: 0,
        neighbours: [neighbour],
        magnetsEnabled: true,
      );

      // Then
      expect(snap.width, 62.5);
      expect(snap.guidesX, [62.5]);
    });

    test('Given the bottom handle and magnets switched off, '
        'when it is dragged onto a magnet, '
        'then the height follows the pointer exactly', () {
      // Given / When — bottom edge would land on 100
      final snap = WindowSnapUtil.snapResize(
        window: window(y: 20, height: 30),
        handle: ResizeHandle.bottom,
        deltaX: 0,
        deltaY: 49.4,
        neighbours: const [],
        magnetsEnabled: false,
      );

      // Then
      expect(snap.height, closeTo(79.4, 0.001));
      expect(snap.hasGuides, isFalse);
    });

    test('Given every handle, '
        'when it is dragged by one percent outwards, '
        'then exactly the edges it owns have moved', () {
      // Given
      final origin = window(x: 30, y: 30, width: 30, height: 30);

      for (final handle in ResizeHandle.values) {
        // When — magnets off so the assertion is about geometry alone
        final snap = WindowSnapUtil.snapResize(
          window: origin,
          handle: handle,
          deltaX: handle.movesLeftEdge ? -1 : 1,
          deltaY: handle.movesTopEdge ? -1 : 1,
          neighbours: const [],
          magnetsEnabled: false,
        );

        // Then
        expect(snap.x, handle.movesLeftEdge ? 29 : 30, reason: '$handle left edge');
        expect(snap.y, handle.movesTopEdge ? 29 : 30, reason: '$handle top edge');
        expect(snap.x + snap.width, handle.movesRightEdge ? 61 : 60, reason: '$handle right edge');
        expect(snap.y + snap.height, handle.movesBottomEdge ? 61 : 60, reason: '$handle bottom edge');
      }
    });
  });
}
