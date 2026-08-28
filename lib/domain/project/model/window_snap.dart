import 'package:freezed_annotation/freezed_annotation.dart';

part 'window_snap.freezed.dart';

/// The result of dragging or resizing a window tile.
///
/// The rectangle is in percent of its monitor, like [ProjectWindow]. [guidesX] and
/// [guidesY] are the percent positions of the magnets that actually caught an edge —
/// the editor draws exactly those as alignment guides, and an empty list means the
/// tile is following the pointer freely.
@freezed
abstract class WindowSnap with _$WindowSnap {
  const factory WindowSnap({
    required double x,
    required double y,
    required double width,
    required double height,
    @Default([]) List<double> guidesX,
    @Default([]) List<double> guidesY,
  }) = _WindowSnap;

  const WindowSnap._();

  bool get hasGuides => guidesX.isNotEmpty || guidesY.isNotEmpty;
}
