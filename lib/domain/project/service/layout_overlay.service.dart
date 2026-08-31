import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/data/system/repository/layout_overlay.repository.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

part 'layout_overlay.service.g.dart';

/// Lets a layout be arranged at full size on the real screens.
///
/// The miniature stage in the editor sheet is fine for a rough arrangement, but on a
/// 27″ display a tile there is a few hundred pixels wide — one cannot judge how large a
/// window will actually be. The overlay puts the same tiles on the real screens at
/// their real size.
@Riverpod(keepAlive: true)
class LayoutOverlayService extends _$LayoutOverlayService {
  @override
  void build() {}

  /// Opens the overlay and returns the edited layout, or null when it was cancelled
  /// or could not be shown at all.
  Future<List<ProjectWindow>?> edit(List<ProjectWindow> windows) async {
    try {
      // Refreshed rather than read: `screensProvider` is keepAlive and a display could
      // have been connected or disconnected since it was last resolved.
      final screens = await ref.refresh(screensProvider.future);
      if (screens.isEmpty) return null;

      // The library travels along so apps can be dropped in from inside the overlay.
      final library = await ref.read(appLibraryProvider.future);

      return await ref
          .read(layoutOverlayRepositoryProvider)
          .edit(windows: windows, screens: screens, library: library, icons: await _iconsFor(windows, library));
    } on Object {
      // The bridge is absent outside macOS and in tests; the sheet stays usable.
      return null;
    }
  }

  /// One icon per distinct app, both for the tiles already placed and for the ones
  /// still waiting in the overlay's row. A failure here costs the icons, not the
  /// overlay, so it is swallowed on purpose.
  Future<Map<String, Uint8List>> _iconsFor(List<ProjectWindow> windows, List<AppLibraryEntry> library) async {
    final bundleIds = {
      for (final window in windows) ?window.bundleId,
      for (final entry in library) ?entry.bundleId,
    }.toList();
    if (bundleIds.isEmpty) return const {};

    try {
      return await ref.read(appLauncherRepositoryProvider).getAppIcons(bundleIds);
    } on Object {
      return const {};
    }
  }
}
