import 'dart:typed_data';

import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';

/// Fetches real app icons, shared by every screen that shows one next to a chip or
/// row — Projects and the App Blocker alike — so the same null-filtering and fallback
/// behaviour lives in one place instead of being copied per feature.
class AppIconsUtil {
  AppIconsUtil._();

  /// PNG icon bytes for a set of bundle ids from the OS, keyed by bundle id.
  ///
  /// Swallows failures rather than throwing: the bridge is absent outside macOS and in
  /// tests, and a missing icon should just mean a row falls back to its glyph, not
  /// that the screen using it stops working.
  static Future<Map<String, Uint8List>> fetch(AppLauncherRepository launcher, Iterable<String?> bundleIds) async {
    final ids = {for (final id in bundleIds) ?id}.toList();
    if (ids.isEmpty) return const {};

    try {
      return await launcher.getAppIcons(ids);
    } on Object {
      return const {};
    }
  }
}
