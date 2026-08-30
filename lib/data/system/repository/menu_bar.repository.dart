import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/project/model/project.dart';

part 'menu_bar.repository.g.dart';

/// Drives the menu bar's `NSStatusItem` — the project launcher, the focus-session
/// toggle, and the running session's countdown alongside it.
class MenuBarRepository {
  MenuBarRepository({required this.channel}) {
    // Registered once, lazily, so construction alone does not touch the channel.
    channel.onCall('statusItemLaunchProject', (arguments) async {
      final projectId = arguments['projectId'];
      if (projectId is int) _launchRequests.add(projectId);
      return null;
    });
    channel.onCall('statusItemToggleFocus', (arguments) async {
      _toggleFocusRequests.add(null);
      return null;
    });
    channel.onCall('statusItemStartFocus', (arguments) async {
      final minutes = arguments['minutes'];
      if (minutes is int) _startFocusRequests.add(minutes);
      return null;
    });
  }

  final MacosBridgeChannel channel;
  final StreamController<int> _launchRequests = StreamController<int>.broadcast();
  final StreamController<void> _toggleFocusRequests = StreamController<void>.broadcast();
  final StreamController<int> _startFocusRequests = StreamController<int>.broadcast();

  /// Shows [title] (the countdown) in the menu bar.
  Future<void> showCountdown(String title) => channel.invoke<void>('setStatusItemTitle', {'title': title});

  /// Removes the countdown when no session is running.
  Future<void> hide() => channel.invoke<void>('setStatusItemTitle', {'title': null});

  /// Rebuilds the project dropdown.
  Future<void> setProjects(List<Project> projects) => channel.invoke<void>('setStatusItemProjects', {
    'projects': [
      for (final project in projects) {'id': project.id, 'name': project.name},
    ],
  });

  /// Switches the dropdown's focus toggle between "Start Focus" and "Stop Focus".
  Future<void> setSessionRunning({required bool isRunning}) =>
      channel.invoke<void>('setStatusItemSessionRunning', {'isRunning': isRunning});

  /// Emits a project's id each time it is chosen from the menu bar dropdown.
  Stream<int> get launchRequests => _launchRequests.stream;

  /// Emits each time the focus toggle is chosen from the menu bar dropdown.
  Stream<void> get toggleFocusRequests => _toggleFocusRequests.stream;

  /// Emits a length in minutes each time a quick-start button is chosen from the
  /// dropdown.
  Stream<int> get startFocusRequests => _startFocusRequests.stream;
}

@Riverpod(keepAlive: true)
MenuBarRepository menuBarRepository(Ref ref) => MenuBarRepository(channel: ref.watch(macosBridgeChannelProvider));
