import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_info.freezed.dart';
part 'screen_info.g.dart';

/// A physical display, as reported by `NSScreen`.
///
/// [visibleFrame] is the area excluding the menu bar and the Dock — the rectangle a
/// project's percentage coordinates are mapped onto.
@freezed
abstract class ScreenInfo with _$ScreenInfo {
  const factory ScreenInfo({
    required int index,
    required double visibleX,
    required double visibleY,
    required double visibleWidth,
    required double visibleHeight,
    required bool isMain,
    double? diagonalInches,
  }) = _ScreenInfo;

  /// Read back from the layout overlay, which runs in its own Flutter engine.
  factory ScreenInfo.fromJson(Map<String, dynamic> json) => _$ScreenInfoFromJson(json);

  const ScreenInfo._();

  double get aspectRatio => visibleHeight == 0 ? 16 / 10 : visibleWidth / visibleHeight;

  /// Diagonal in inches, rounded for the "Monitor 1 · 27″" caption.
  String get diagonalLabel => diagonalInches == null ? '—' : diagonalInches!.round().toString();

  /// Converts a percentage rectangle of this screen into absolute screen points.
  ///
  /// Percentages come from [ProjectWindow]; the result is what `AXUIElement` expects.
  ({double x, double y, double width, double height}) rectFromPercent({
    required double x,
    required double y,
    required double width,
    required double height,
  }) => (
    x: visibleX + visibleWidth * (x / 100),
    y: visibleY + visibleHeight * (y / 100),
    width: math.max(1, visibleWidth * (width / 100)),
    height: math.max(1, visibleHeight * (height / 100)),
  );

  /// The inverse of [rectFromPercent]: turns an absolute window frame into percentages
  /// of this screen, clamped so a window hanging over an edge still yields a usable
  /// layout rather than values outside 0–100.
  ({double x, double y, double width, double height}) percentFromRect({
    required double x,
    required double y,
    required double width,
    required double height,
  }) {
    if (visibleWidth <= 0 || visibleHeight <= 0) return (x: 0, y: 0, width: 100, height: 100);

    final left = ((x - visibleX) / visibleWidth * 100).clamp(0.0, 100.0);
    final top = ((y - visibleY) / visibleHeight * 100).clamp(0.0, 100.0);

    return (
      x: left,
      y: top,
      width: (width / visibleWidth * 100).clamp(1.0, 100 - left),
      height: (height / visibleHeight * 100).clamp(1.0, 100 - top),
    );
  }

  /// Area of an absolute rectangle that falls on this screen, in square points.
  ///
  /// Used to decide which display a captured window belongs to when it straddles two.
  double overlapArea({required double x, required double y, required double width, required double height}) {
    final overlapWidth = math.min(x + width, visibleX + visibleWidth) - math.max(x, visibleX);
    final overlapHeight = math.min(y + height, visibleY + visibleHeight) - math.max(y, visibleY);
    if (overlapWidth <= 0 || overlapHeight <= 0) return 0;
    return overlapWidth * overlapHeight;
  }
}
