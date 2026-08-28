import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/common/utils/platform_info.dart';

/// Keeps a provider alive for [duration].
extension RiverpodCacheTimeExtension on Ref {
  void cacheFor(Duration duration) {
    // Avoid dangling timers during widget tests.
    if (PlatformInfo.isTestMode == false) {
      final link = keepAlive();
      final timer = Timer(duration, link.close);
      onDispose(timer.cancel);
    }
  }
}
