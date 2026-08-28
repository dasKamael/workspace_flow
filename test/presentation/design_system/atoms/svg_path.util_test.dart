import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/presentation/design_system/atoms/svg_path.util.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';

void main() {
  group('SvgPathUtil.parse', () {
    test('Given a path with absolute line commands, '
        'when it is parsed, '
        'then the bounds span the described rectangle', () {
      // Given / When
      final path = SvgPathUtil.parse('M2 4L10 4L10 12L2 12Z');

      // Then
      expect(path.getBounds(), const Rect.fromLTRB(2, 4, 10, 12));
    });

    test('Given a path using relative commands, '
        'when it is parsed, '
        'then the offsets accumulate from the current point', () {
      // Given / When
      final path = SvgPathUtil.parse('M5 5l5 0l0 5z');

      // Then
      expect(path.getBounds(), const Rect.fromLTRB(5, 5, 10, 10));
    });

    test('Given an arc whose flags are written without separators ("a4.5 4.5 0 10-9 0"), '
        'when it is parsed, '
        'then the flags are read as single digits and the arc ends 9 units to the left', () {
      // Given / When — the shackle of the padlock icon
      final path = SvgPathUtil.parse(UiIcon.lockShackle);
      final bounds = path.getBounds();

      // Then — starts at x=16.5, sweeps to x=7.5, so the arc spans exactly 9 units
      expect(bounds.left, closeTo(7.5, 0.01));
      expect(bounds.right, closeTo(16.5, 0.01));
      // ... and reaches above the start point (the curve of the shackle)
      expect(bounds.top, lessThan(6.75));
    });

    test('Given each icon of the design system, '
        'when it is parsed, '
        'then it produces a non-empty path roughly inside its view box', () {
      // Given
      const outline = <String>[
        UiIcon.folder,
        UiIcon.noSymbol,
        UiIcon.lockShackle,
        UiIcon.lockBody,
        UiIcon.xMark,
        UiIcon.plus,
      ];

      for (final data in <String>[...outline, UiIcon.checkSolid]) {
        // When
        final bounds = SvgPathUtil.parse(data).getBounds();

        // Then
        expect(bounds.isEmpty, isFalse, reason: data);
        // getBounds() bounds an arc by its control points, so it overshoots the true
        // extent slightly — the tolerance keeps the check meaningful without being brittle.
        expect(bounds.left, greaterThanOrEqualTo(-1.5), reason: data);
        expect(bounds.right, lessThanOrEqualTo(25.5), reason: data);
      }
    });

    test('Given a path and a target size, '
        'when it is scaled, '
        'then the bounds fit within that size', () {
      // Given / When
      final path = SvgPathUtil.scaled(UiIcon.checkSolid, viewBox: UiIcon.solidViewBox, size: 11);

      // Then
      expect(path.getBounds().right, lessThanOrEqualTo(11.0));
    });
  });
}
