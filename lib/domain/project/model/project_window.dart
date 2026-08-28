import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_window.freezed.dart';

/// One window of a project layout.
///
/// [x], [y], [width] and [height] are percentages (0–100) of the target screen's
/// visible frame, so a layout survives a resolution change and can be previewed in the
/// editor's monitor stage at any scale.
///
/// Exactly one of [bundleId] (an app) or [url] (a website) identifies what to open;
/// [name] is what the UI shows.
@freezed
abstract class ProjectWindow with _$ProjectWindow {
  const factory ProjectWindow({
    required int id,
    required String name,
    required int screenIndex,
    required double x,
    required double y,
    required double width,
    required double height,
    String? bundleId,
    String? url,
    @Default(0) int sortOrder,
  }) = _ProjectWindow;

  const ProjectWindow._();

  /// Smallest allowed edge of a window tile, in percent.
  static const double minSize = 15;

  bool get isWebsite => url != null;
}
