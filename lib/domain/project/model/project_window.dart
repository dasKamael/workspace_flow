import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_window.freezed.dart';
part 'project_window.g.dart';

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

    /// A folder or file to open with [bundleId] — a specific project rather than just
    /// the app in general. Set from an AppLibraryEntry carrying the same field.
    String? documentPath,
    @Default(0) int sortOrder,

    /// The [ScreenInfo.displayId] this window was placed on, captured at arrange time.
    ///
    /// Preferred over [screenIndex] when launching: `NSScreen.screens`' array order
    /// isn't guaranteed stable across sleep/wake or a monitor reconnect, so the index
    /// alone can point at the wrong physical display even though it stays in range.
    /// Null for windows saved before this field existed, or if the display reported
    /// none — [screenIndex] is still the fallback for those.
    int? displayId,
  }) = _ProjectWindow;

  /// Read back from the layout overlay, which runs in its own Flutter engine and can
  /// only be reached over a method channel.
  factory ProjectWindow.fromJson(Map<String, dynamic> json) => _$ProjectWindowFromJson(json);

  const ProjectWindow._();

  /// Smallest allowed edge of a window tile, in percent.
  static const double minSize = 15;

  /// Size a freshly placed window starts at, in percent of its monitor.
  static const double defaultWidth = 50;
  static const double defaultHeight = 100;

  /// Places [entry] centred on a drop at ([x], [y]), clamped inside the monitor.
  ///
  /// Shared by the editor and the overlay so a dropped app lands the same way in both.
  static ProjectWindow fromDrop({
    required int id,
    required String name,
    required int screenIndex,
    required double x,
    required double y,
    String? bundleId,
    String? url,
    String? documentPath,
    int? displayId,
  }) => ProjectWindow(
    id: id,
    name: name,
    bundleId: bundleId,
    url: url,
    documentPath: documentPath,
    screenIndex: screenIndex,
    displayId: displayId,
    x: _clamp(x - defaultWidth / 2, defaultWidth),
    y: _clamp(y - defaultHeight / 2, defaultHeight),
    width: defaultWidth,
    height: defaultHeight,
  );

  static double _clamp(double value, double size) => value.clamp(0, (100 - size).clamp(0, 100));

  bool get isWebsite => url != null;

  /// Same identity logic as [AppLibraryEntry.key] — lets the overlay hide only the
  /// library chip that matches this exact window, not every chip sharing its app.
  String get libraryKey {
    if (url != null) return url!;
    if (documentPath != null) return '$bundleId|$documentPath';
    return bundleId ?? name;
  }
}
