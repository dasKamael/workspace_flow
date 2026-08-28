import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/screen.repository.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';

part 'screen.service.g.dart';

/// The attached displays.
///
/// Falls back to a single 16:10 stage when the native side is unavailable (tests, other
/// platforms) so the editor always has something to draw.
@Riverpod(keepAlive: true)
Future<List<ScreenInfo>> screens(Ref ref) async {
  try {
    final screens = await ref.watch(screenRepositoryProvider).getScreens();
    return screens.isEmpty ? _fallback : screens;
  } on Object {
    return _fallback;
  }
}

const List<ScreenInfo> _fallback = [
  ScreenInfo(index: 0, visibleX: 0, visibleY: 0, visibleWidth: 1920, visibleHeight: 1200, isMain: true),
];
