import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';

part 'layout_overlay.repository.g.dart';

/// Opens the full-size layout overlay and waits for its result.
///
/// The overlay runs in a second Flutter engine, so the round trip goes out over the
/// method channel and comes back as an inbound call. That asynchrony is hidden here:
/// callers just await a list of windows, or null when the overlay was cancelled.
class LayoutOverlayRepository {
  LayoutOverlayRepository({required this.channel}) {
    channel.onCall(_appliedMethod, _onApplied);
    channel.onCall(_cancelledMethod, _onCancelled);
  }

  final MacosBridgeChannel channel;

  static const String _appliedMethod = 'layoutOverlayApplied';
  static const String _cancelledMethod = 'layoutOverlayCancelled';

  Completer<List<ProjectWindow>?>? _pending;

  /// Whether an overlay is currently open.
  bool get isOpen => _pending != null;

  /// Shows the overlay with [windows] laid out on [screens].
  ///
  /// [library] and [icons] carry the apps that can still be dropped in and their
  /// icons: the overlay engine has no plugins or providers of its own, so everything
  /// it needs has to travel with the payload.
  ///
  /// Returns the edited layout, or null when the user cancelled. A second call while
  /// one is already open returns null rather than opening a competing overlay.
  Future<List<ProjectWindow>?> edit({
    required List<ProjectWindow> windows,
    required List<ScreenInfo> screens,
    List<AppLibraryEntry> library = const [],
    Map<String, Uint8List> icons = const {},
  }) async {
    if (_pending != null) return null;

    final completer = Completer<List<ProjectWindow>?>();
    _pending = completer;

    try {
      await channel.invoke<void>('showLayoutOverlay', {
        'windows': [for (final window in windows) window.toJson()],
        'screens': [for (final screen in screens) screen.toJson()],
        'library': [for (final entry in library) entry.toJson()],
        'icons': icons,
      });
    } on Object {
      _pending = null;
      rethrow;
    }

    return completer.future;
  }

  Future<Object?> _onApplied(Map<String, Object?> arguments) async {
    final raw = arguments['windows'];
    final windows = raw is List
        ? [
            for (final entry in raw.whereType<Map<Object?, Object?>>())
              ProjectWindow.fromJson(entry.map((key, value) => MapEntry(key.toString(), value))),
          ]
        : <ProjectWindow>[];

    _complete(windows);
    return null;
  }

  Future<Object?> _onCancelled(Map<String, Object?> arguments) async {
    _complete(null);
    return null;
  }

  void _complete(List<ProjectWindow>? windows) {
    final pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) pending.complete(windows);
  }
}

@Riverpod(keepAlive: true)
LayoutOverlayRepository layoutOverlayRepository(Ref ref) =>
    LayoutOverlayRepository(channel: ref.watch(macosBridgeChannelProvider));
