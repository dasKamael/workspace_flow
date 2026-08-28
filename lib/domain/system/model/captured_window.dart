import 'package:freezed_annotation/freezed_annotation.dart';

part 'captured_window.freezed.dart';

/// A window that is open right now, as read from the accessibility API.
///
/// The frame is in absolute screen points, in the same top-left coordinate space
/// `ScreenInfo` uses — turning it into a layout is `WindowCaptureService`'s job.
@freezed
abstract class CapturedWindow with _$CapturedWindow {
  const factory CapturedWindow({
    required String name,
    required String bundleId,
    required double x,
    required double y,
    required double width,
    required double height,
  }) = _CapturedWindow;
}
