import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/service/launch.service.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_shadow.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_fade_up.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_link_label.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_card.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/shared_widgets/async_value_widget.dart';

/// The left column: the list of saved layouts.
class ProjectsCard extends ConsumerWidget {
  const ProjectsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    // The same derived provider the workspace uses, so the highlight can never
    // disagree with the project actually being shown.
    final selected = ref.watch(selectedProjectProvider);

    return UiCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translations.projects_label.toUpperCase(), style: UiTypography.cardLabel),
              UiLinkLabel(
                label: context.translations.common_new,
                onTap: () => context.goNamed(
                  UiRoute.projectEditor.name,
                  pathParameters: {RoutePathParam.id.name: kNewEntitySegment},
                ),
              ),
            ],
          ),
          UiSpacer.l,
          Expanded(
            child: AsyncValueWidget<List<Project>>(
              value: projects,
              data: (projects) => ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: projects.length,
                separatorBuilder: (_, _) => UiSpacer.sm,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return UiFadeUp(
                    delay: UiMotion.cardStagger * index,
                    child: _ProjectTile(
                      project: project,
                      isActive: project.id == selected?.id,
                      onSelect: () {
                        ref.read(selectedProjectServiceProvider.notifier).select(project.id);
                        ref.read(launchServiceProvider.notifier).reset();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          UiSpacer.l,
          const _CardFooterDivider(),
          UiSpacer.l,
          Text(context.translations.projects_footer_hint, style: UiTypography.body),
        ],
      ),
    );
  }
}

class _CardFooterDivider extends StatelessWidget {
  const _CardFooterDivider();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 1, child: ColoredBox(color: UiColor.border));
}

class _ProjectTile extends ConsumerWidget {
  const _ProjectTile({required this.project, required this.isActive, required this.onSelect});

  final Project project;
  final bool isActive;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) => UiHoverRegion(
    builder: (context, isHovered) => GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: UiMotion.fast,
        curve: UiMotion.ease,
        transform: Matrix4.translationValues(0, isHovered ? UiMotion.liftProjectCard : 0, 0),
        padding: const EdgeInsets.all(UiSize.ml),
        decoration: BoxDecoration(
          color: isActive ? UiColor.bgAccent : UiColor.white,
          borderRadius: UiRadius.allXl,
          border: Border.all(color: isActive ? UiColor.borderAccentStrong : UiColor.border),
          boxShadow: isHovered ? UiShadow.md : const [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: UiSize.statusDot,
                  height: UiSize.statusDot,
                  decoration: BoxDecoration(
                    color: isActive ? UiColor.primary : UiColor.inactive,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    project.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: UiTypography.itemTitle,
                  ),
                ),
                UiLinkLabel(
                  label: context.translations.common_edit,
                  color: UiColor.fgSubtle,
                  hoverColor: UiColor.fgAccent,
                  onTap: () => context.goNamed(
                    UiRoute.projectEditor.name,
                    pathParameters: {RoutePathParam.id.name: '${project.id}'},
                  ),
                ),
              ],
            ),
            UiSpacer.xs,
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text(
                context.translations.projects_subtitle(project.windowCount),
                style: UiTypography.itemSubtitle,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
