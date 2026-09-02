import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/focus/service/focus_session.service.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_window_title_bar.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/screens/focus_running/focus_running.screen.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/blocker_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/focus_session_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/projects_card.dart';
import 'package:workspace_flow/presentation/screens/workspace/widgets/workspace_card.dart';

/// The app window: title bar plus either the three-column body or, while a session
/// runs, the distraction-free session view.
class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    final isRunning = ref.watch(focusSessionServiceProvider.select((session) => session.isRunning));

    return Scaffold(
      backgroundColor: UiColor.bgSubtle,
      body: Column(
        children: [
          UiWindowTitleBar(
            title: isRunning
                ? context.translations.window_title_running
                : context.translations.window_title_idle(project?.name ?? ''),
            isSessionRunning: isRunning,
            onSettingsTap: isRunning ? null : () => context.goNamed(UiRoute.settings.name),
          ),
          Expanded(
            // Clipped so the start burst cannot paint over the title bar.
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: UiMotion.focusIn,
                switchInCurve: UiMotion.ease,
                // The default layout builder stacks the children loosely, which lets
                // each one shrink to its content — the session view would end up a
                // small box in the middle of the window. StackFit.expand hands both
                // views the full body instead.
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [...previousChildren, ?currentChild],
                ),
                // `focusIn` — the session view fades and scales in from 0.97.
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation.drive(Tween(begin: 0.97, end: 1.0)), child: child),
                ),
                child: isRunning
                    ? const FocusRunningScreen(key: ValueKey('running'))
                    : _WorkspaceBody(key: const ValueKey('idle'), project: project),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceBody extends StatelessWidget {
  const _WorkspaceBody({required this.project, super.key});

  final Project? project;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(UiSize.l),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Expanded(child: ProjectsCard()),
        UiSpacer.l,
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkspaceCard(project: project),
              // The session card is pinned to the bottom so it never shifts when a
              // different project — with a different number of rows — is selected.
              const Spacer(),
              UiSpacer.l,
              const FocusSessionCard(),
            ],
          ),
        ),
        UiSpacer.l,
        const Expanded(child: BlockerCard()),
      ],
    ),
  );
}
