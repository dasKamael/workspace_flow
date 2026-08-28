import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/model/resize_handle.enum.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/monitor_stage.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/snap_guide.painter.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_tile.dart';

import '../../../widgettest.test_util.dart';

/// The stage owns the drag maths: it measures every frame from the rectangle the drag
/// started on, which is what keeps a tile glued to the pointer and lets it leave a
/// magnet again.
void main() {
  const screens = [
    ScreenInfo(
      index: 0,
      visibleX: 0,
      visibleY: 25,
      visibleWidth: 2560,
      visibleHeight: 1415,
      isMain: true,
      diagonalInches: 26.8,
    ),
  ];

  /// Records what the stage reported, the way the controller would receive it.
  late List<({double x, double y, int screenIndex, ProjectWindow origin, bool magnets})> moves;
  late List<({ResizeHandle handle, double deltaX, double deltaY, bool magnets})> resizes;
  late int dragEnds;

  setUp(() {
    moves = [];
    resizes = [];
    dragEnds = 0;
  });

  Future<void> pumpStage(
    WidgetTester tester, {
    required List<ProjectWindow> windows,
    List<double> guidesX = const [],
    List<double> guidesY = const [],
    int? draggingIndex,
  }) => pumpAppWidget(
    tester,
    surfaceSize: const Size(800, 600),
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 640,
        child: MonitorStage(
          screens: screens,
          windows: windows,
          selectedIndex: null,
          draggingIndex: draggingIndex,
          guidesX: guidesX,
          guidesY: guidesY,
          onSelect: (_) {},
          onRemove: (_) {},
          onPlace: ({required entry, required screenIndex, required x, required y}) {},
          onMove:
              ({
                required index,
                required screenIndex,
                required x,
                required y,
                required origin,
                required magnetsEnabled,
              }) => moves.add((x: x, y: y, screenIndex: screenIndex, origin: origin, magnets: magnetsEnabled)),
          onResize:
              ({
                required index,
                required handle,
                required deltaX,
                required deltaY,
                required origin,
                required magnetsEnabled,
              }) => resizes.add((handle: handle, deltaX: deltaX, deltaY: deltaY, magnets: magnetsEnabled)),
          onDragEnd: () => dragEnds++,
        ),
      ),
    ),
  );

  const window = ProjectWindow(id: 1, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 50, height: 50);

  testWidgets('Given a tile on the stage, '
      'when it is dragged, '
      'then every update reports a target measured from the drag origin', (tester) async {
    // Given
    await pumpStage(tester, windows: const [window]);
    final monitorSize = tester.getSize(find.byType(AspectRatio));

    // When — the first move only gets the drag past the touch slop and fixes the
    // origin; the two after it are the actual travel
    final gesture = await tester.startGesture(tester.getCenter(find.byType(WindowTile)));
    await tester.pump();
    for (var step = 0; step < 3; step++) {
      await gesture.moveBy(Offset(monitorSize.width / 8, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pump();

    // Then — the second update reports 25%, not 12.5% again: it measures the total
    // travel from the origin rather than adding a delta to the last value
    expect(moves, hasLength(2));
    expect(moves.first.x, closeTo(12.5, 0.1));
    expect(moves.last.x, closeTo(25, 0.1));
    expect(moves.every((move) => move.origin == window), isTrue);
    expect(dragEnds, 1);
  });

  testWidgets('Given a tile with all eight grips, '
      'when the bottom-right corner is dragged, '
      'then the stage reports that handle with the travel in percent', (tester) async {
    // Given
    await pumpStage(tester, windows: const [window]);
    final tileRect = tester.getRect(find.byType(WindowTile));
    final monitorSize = tester.getSize(find.byType(AspectRatio));

    // When — grabbing just inside the bottom-right corner; the first move only gets
    // the gesture past the touch slop
    final gesture = await tester.startGesture(tileRect.bottomRight - const Offset(4, 4));
    await tester.pump();
    for (var step = 0; step < 2; step++) {
      await gesture.moveBy(Offset(monitorSize.width / 10, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pump();

    // Then
    expect(resizes, isNotEmpty);
    expect(resizes.last.handle, ResizeHandle.bottomRight);
    expect(resizes.last.deltaX, closeTo(10, 0.5));
    expect(dragEnds, 1);
  });

  testWidgets('Given a tile with all eight grips, '
      'when the left edge is dragged, '
      'then the left handle is reported rather than a move', (tester) async {
    // Given
    await pumpStage(tester, windows: const [window]);
    final tileRect = tester.getRect(find.byType(WindowTile));

    // When — the middle of the left edge. A pan needs kPanSlop (twice the touch
    // slop) before it starts, so the first steps only get the gesture going.
    final gesture = await tester.startGesture(Offset(tileRect.left + 2, tileRect.center.dy));
    await tester.pump();
    for (var step = 0; step < 3; step++) {
      await gesture.moveBy(const Offset(-30, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pump();

    // Then — grabbing an edge resizes; it must not fall through to the move gesture
    expect(resizes.last.handle, ResizeHandle.left);
    expect(moves, isEmpty);
  });

  testWidgets('Given guides reported for a dragged tile, '
      'when the stage renders, '
      'then they are painted on that monitor', (tester) async {
    // Given / When
    await pumpStage(tester, windows: const [window], guidesX: const [50], draggingIndex: 0);

    // Then
    final painters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((paint) => paint.painter is SnapGuidePainter);
    expect(painters, hasLength(1));
    expect((painters.single.painter! as SnapGuidePainter).guidesX, [50]);
  });

  testWidgets('Given no drag in progress, '
      'when the stage renders, '
      'then no guides are painted', (tester) async {
    // Given / When
    await pumpStage(tester, windows: const [window]);

    // Then
    expect(
      tester.widgetList<CustomPaint>(find.byType(CustomPaint)).where((paint) => paint.painter is SnapGuidePainter),
      isEmpty,
    );
  });
}
