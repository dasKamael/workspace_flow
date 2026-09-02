import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/system/app_icons.util.dart';

part 'app_icons.service.g.dart';

/// PNG icon bytes for a set of bundle ids, keyed by bundle id.
///
/// The generic counterpart to `appLibraryIconsProvider`/`blockerItemIconsProvider` —
/// for callers that just need a few icons for bundle ids that aren't already backed by
/// a library or profile, e.g. windows captured straight off the desktop.
@riverpod
Future<Map<String, Uint8List>> appIconsFor(Ref ref, Iterable<String?> bundleIds) =>
    AppIconsUtil.fetch(ref.read(appLauncherRepositoryProvider), bundleIds);
