import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/model/launch_progress.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/launch.service.dart';
import 'package:workspace_flow/domain/system/service/permission.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_fade_up.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_link_label.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_tick_box.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_card.dart';

/// The top of the middle column: the selected project and its windows.
class WorkspaceCard extends ConsumerWidget {
  const WorkspaceCard({required this.project, super.key});

  final Project? project;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(launchServiceProvider);
    final windows = project?.windows ?? const <ProjectWindow>[];

    return UiCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: UiSize.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: UiTypography.headline,
                ),
              ),
              UiSpacer.l,
              UiPrimaryButton(
                label: _launchLabel(context, progress),
                background: progress.hasLaunched ? UiColor.primaryDone : UiColor.primary,
                onPressed: project == null || progress.isLaunching
                    ? null
                    : () => ref.read(launchServiceProvider.notifier).launch(project!),
              ),
            ],
          ),
          if (progress.needsAccessibilityPermission) ...[
            const _AccessibilityPermissionBanner(),
            UiSpacer.l,
          ],
          UiSpacer.l,
          // Re-keyed on the project so the row cascade replays when the selection changes.
          Column(
            key: ValueKey(project?.id),
            children: [
              for (final (index, window) in windows.indexed)
                UiFadeUp(
                  duration: UiMotion.rowIn,
                  delay: UiMotion.rowStagger * index,
                  child: _WindowRow(window: window, step: progress.stepFor(window.id)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _launchLabel(BuildContext context, LaunchProgress progress) {
    if (progress.isLaunching) return context.translations.workspace_launching;
    if (progress.hasLaunched) return context.translations.workspace_rearrange;
    return context.translations.workspace_launch;
  }
}

/// Shown above the window rows when the last launch could not position anything —
/// the apps still opened, but landed wherever macOS put them instead of where the
/// project saved them.
class _AccessibilityPermissionBanner extends ConsumerWidget {
  const _AccessibilityPermissionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    padding: const EdgeInsets.all(UiSize.m),
    decoration: BoxDecoration(color: UiColor.bgAccent, borderRadius: UiRadius.allM),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.translations.permission_accessibility_title, style: UiTypography.cardLabel),
              UiSpacer.xs,
              Text(context.translations.permission_accessibility_body, style: UiTypography.hint),
            ],
          ),
        ),
        UiSpacer.m,
        UiLinkLabel(
          label: context.translations.permission_accessibility_open_settings,
          onTap: () => ref.read(accessibilityPermissionServiceProvider.notifier).request(),
        ),
      ],
    ),
  );
}

class _WindowRow extends StatelessWidget {
  const _WindowRow({required this.window, required this.step});

  final ProjectWindow window;
  final LaunchStep step;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    cursor: MouseCursor.defer,
    builder: (context, isHovered) => AnimatedContainer(
      duration: UiMotion.fast,
      curve: UiMotion.ease,
      padding: const EdgeInsets.symmetric(horizontal: UiSize.xs, vertical: UiSize.s),
      decoration: BoxDecoration(color: isHovered ? UiColor.bgSubtle : UiColor.white, borderRadius: UiRadius.allM),
      child: Stack(
        children: [
          Row(
            children: [
              UiTickBox(checked: step == LaunchStep.open),
              const SizedBox(width: UiSize.m),
              Expanded(
                child: Text(window.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: UiTypography.appName),
              ),
              Text(_stateLabel(context), style: UiTypography.rowState.copyWith(color: _stateColor)),
            ],
          ),
          if (step == LaunchStep.opening) const Positioned(left: 0, right: 0, bottom: 0, child: _RowProgressBar()),
        ],
      ),
    ),
  );

  String _stateLabel(BuildContext context) => switch (step) {
    LaunchStep.pending => context.translations.workspace_window_state_pending,
    LaunchStep.opening => context.translations.workspace_window_state_opening,
    LaunchStep.open => context.translations.workspace_window_state_open,
    LaunchStep.failed => context.translations.workspace_window_state_failed,
  };

  Color get _stateColor => switch (step) {
    LaunchStep.pending => UiColor.fgDisabled,
    LaunchStep.opening => UiColor.fg,
    LaunchStep.open => UiColor.primary,
    LaunchStep.failed => UiColor.fgSubtle,
  };
}

/// `barGrow` — a 2px bar filling left to right while the window opens.
class _RowProgressBar extends StatefulWidget {
  const _RowProgressBar();

  @override
  State<_RowProgressBar> createState() => _RowProgressBarState();
}

class _RowProgressBarState extends State<_RowProgressBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.barGrow)..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: UiSize.progressBarHeight,
    child: ColoredBox(
      color: UiColor.track,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: _controller.value,
          child: const ColoredBox(color: UiColor.accent),
        ),
      ),
    ),
  );
}
