import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';

void main() {
  // A 2560×1440 display whose visible frame starts below a 25pt menu bar.
  const screen = ScreenInfo(
    index: 0,
    visibleX: 0,
    visibleY: 25,
    visibleWidth: 2560,
    visibleHeight: 1415,
    isMain: true,
    diagonalInches: 26.8,
  );

  test('Given a window saved as the left 62.5% of the screen, '
      'when it is mapped onto the visible frame, '
      'then it lands at the frame origin with the matching width', () {
    // Given / When
    final rect = screen.rectFromPercent(x: 0, y: 0, width: 62.5, height: 100);

    // Then — the menu bar offset is respected
    expect(rect.x, 0);
    expect(rect.y, 25);
    expect(rect.width, 1600);
    expect(rect.height, 1415);
  });

  test('Given a window in the lower right quadrant, '
      'when it is mapped, '
      'then its origin is offset by the same fractions', () {
    // Given / When
    final rect = screen.rectFromPercent(x: 50, y: 50, width: 50, height: 50);

    // Then
    expect(rect.x, 1280);
    expect(rect.y, 25 + 707.5);
    expect(rect.width, 1280);
    expect(rect.height, 707.5);
  });

  test('Given a degenerate zero-size window, '
      'when it is mapped, '
      'then it keeps at least one point so the window stays addressable', () {
    // Given / When
    final rect = screen.rectFromPercent(x: 0, y: 0, width: 0, height: 0);

    // Then
    expect(rect.width, 1);
    expect(rect.height, 1);
  });

  test('Given a display of 26.8 inches, '
      'when its caption is rendered, '
      'then the diagonal is rounded to whole inches', () {
    // Given / When / Then — "Monitor 1 · 27″"
    expect(screen.diagonalLabel, '27');
  });

  test('Given a display whose size the system does not report, '
      'when its caption is rendered, '
      'then it falls back to a dash instead of a wrong number', () {
    // Given
    const unknown = ScreenInfo(
      index: 1,
      visibleX: 0,
      visibleY: 0,
      visibleWidth: 1920,
      visibleHeight: 1200,
      isMain: false,
    );

    // When / Then
    expect(unknown.diagonalLabel, '—');
  });
}
