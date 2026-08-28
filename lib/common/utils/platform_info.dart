import 'dart:io';

import 'package:flutter/foundation.dart';

/// Single entry point for platform and build-mode checks.
///
/// Direct use of [kDebugMode], [kReleaseMode] or `dart:io`'s `Platform` is forbidden
/// everywhere else so that tests can reason about the environment — enforced by
/// `test/architecture/abstraction_test.dart`.
class PlatformInfo {
  PlatformInfo._();

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  static bool get isReleaseMode => kReleaseMode;
  static bool get isDebugMode => kDebugMode;
  static bool get isTestMode => Platform.environment.containsKey('FLUTTER_TEST');
  static String get operatingSystemVersion => Platform.operatingSystemVersion;
  static String get localeName => Platform.localeName;
}
