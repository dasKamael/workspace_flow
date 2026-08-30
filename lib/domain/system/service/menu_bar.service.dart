import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/domain/project/service/launch.service.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';

part 'menu_bar.service.g.dart';

/// Keeps the menu bar's project dropdown in sync, and launches whichever one is picked
/// from it.
///
/// Read once during bootstrap so it stays alive for the whole app — including while the
/// main window is closed, which is the entire point of a menu bar launcher.
@Riverpod(keepAlive: true)
class MenuBarService extends _$MenuBarService {
  @override
  void build() {
    ref.listen(projectsProvider, (_, next) {
      final projects = next.valueOrNull;
      if (projects == null) return;
      unawaited(ref.read(menuBarRepositoryProvider).setProjects(projects).catchError((_) {}));
    }, fireImmediately: true);

    final subscription = ref.read(menuBarRepositoryProvider).launchRequests.listen(_handleLaunchRequest);
    ref.onDispose(subscription.cancel);
  }

  Future<void> _handleLaunchRequest(int projectId) async {
    final projects = await ref.read(projectsProvider.future);
    final project = projects.where((project) => project.id == projectId).firstOrNull;
    if (project != null) await ref.read(launchServiceProvider.notifier).launch(project);
  }
}
