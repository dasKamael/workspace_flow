import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';

part 'screen.repository.g.dart';

/// Reads the attached displays from `NSScreen`.
class ScreenRepository {
  ScreenRepository({required this.channel});

  final MacosBridgeChannel channel;

  /// The displays in `NSScreen.screens` order — index 0 is "Monitor 1" in the editor.
  Future<List<ScreenInfo>> getScreens() async {
    final rows = await channel.invokeList('getScreens');
    return [
      for (final (index, row) in rows.indexed)
        ScreenInfo(
          index: index,
          visibleX: _toDouble(row['visibleX']),
          visibleY: _toDouble(row['visibleY']),
          visibleWidth: _toDouble(row['visibleWidth']),
          visibleHeight: _toDouble(row['visibleHeight']),
          isMain: row['isMain'] == true,
          diagonalInches: row['diagonalInches'] == null ? null : _toDouble(row['diagonalInches']),
        ),
    ];
  }

  static double _toDouble(Object? value) => value is num ? value.toDouble() : 0;
}

@Riverpod(keepAlive: true)
ScreenRepository screenRepository(Ref ref) => ScreenRepository(channel: ref.watch(macosBridgeChannelProvider));
