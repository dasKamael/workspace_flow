import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/focus/model/focus_session.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/focus_dial.dart';

void main() {
  const size = Size(200, 200);
  const centre = Offset(100, 100);

  double minutesAt(Offset position) => minutesFromOffset(position, size, maxMinutes: FocusSession.maxMinutes);

  test('Given a pointer straight above the centre, '
      'when the angle is mapped, '
      'then it reads zero minutes — twelve o\'clock is the origin', () {
    // Given / When / Then
    expect(minutesAt(centre - const Offset(0, 80)), closeTo(0, 0.01));
  });

  test('Given pointers at three, six and nine o\'clock, '
      'when the angles are mapped, '
      'then the dial runs clockwise across its 120 minute range', () {
    // Given / When / Then
    expect(minutesAt(centre + const Offset(80, 0)), closeTo(30, 0.01));
    expect(minutesAt(centre + const Offset(0, 80)), closeTo(60, 0.01));
    expect(minutesAt(centre - const Offset(80, 0)), closeTo(90, 0.01));
  });

  test('Given a pointer just anticlockwise of twelve, '
      'when the angle is mapped, '
      'then it wraps to the top of the range instead of going negative', () {
    // Given — slightly left of straight up
    final minutes = minutesAt(centre + const Offset(-1, -80));

    // Then
    expect(minutes, greaterThan(119));
    expect(minutes, lessThanOrEqualTo(120));
  });

  test('Given pointers at different distances on the same ray, '
      'when the angles are mapped, '
      'then only the direction matters', () {
    // Given / When / Then — dragging outside the dial keeps working
    expect(minutesAt(centre + const Offset(20, 20)), closeTo(minutesAt(centre + const Offset(300, 300)), 0.01));
  });
}
