import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_chip.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_link_label.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_text_field.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_sheet.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.controller.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/monitor_stage.dart';

/// The project editor sheet: name, sources on the left, window layout on the right.
class ProjectEditorScreen extends ConsumerStatefulWidget {
  const ProjectEditorScreen({required this.projectId, super.key});

  /// Null when creating a new project.
  final int? projectId;

  @override
  ConsumerState<ProjectEditorScreen> createState() => _ProjectEditorScreenState();
}

class _ProjectEditorScreenState extends ConsumerState<ProjectEditorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  bool _didPrefillName = false;

  /// Set when capturing found nothing, so the hint can explain why.
  bool _captureFailed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  ProjectEditorController get _controller => ref.read(projectEditorControllerProvider(widget.projectId).notifier);

  void _close() => context.goNamed(UiRoute.workspace.name);

  Future<void> _save() async {
    await _controller.save(fallbackName: context.translations.project_editor_untitled);
    if (mounted) _close();
  }

  Future<void> _delete() async {
    await _controller.delete();
    if (mounted) _close();
  }

  /// Adds a typed website to the library and places it right away.
  Future<void> _addWebsite() async {
    final raw = _websiteController.text.trim();
    if (raw.isEmpty) return;
    _websiteController.clear();

    final entry = AppLibraryEntry(name: raw, url: raw.startsWith('http') ? raw : 'https://$raw');
    await ref.read(projectServiceProvider.notifier).addToLibrary(entry);
    _controller.place(entry: entry, screenIndex: 0, x: 25, y: 50);
  }

  /// Freezes the windows that are open right now into the draft.
  Future<void> _captureCurrentArrangement() async {
    final captured = await _controller.captureCurrentArrangement();
    if (captured || !mounted) return;
    setState(() => _captureFailed = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectEditorControllerProvider(widget.projectId));
    final screens = ref.watch(screensProvider).valueOrNull ?? const <ScreenInfo>[];
    final library = ref.watch(appLibraryProvider).valueOrNull ?? const <AppLibraryEntry>[];

    if (state.isLoaded && !_didPrefillName) {
      _didPrefillName = true;
      _nameController.text = state.name;
    }

    final stage = MonitorStage(
      screens: screens,
      windows: state.windows,
      selectedIndex: state.selectedIndex,
      draggingIndex: state.draggingIndex,
      guidesX: state.guidesX,
      guidesY: state.guidesY,
      onSelect: _controller.select,
      onRemove: _controller.remove,
      onPlace: _controller.place,
      onMove: _controller.move,
      onResize: _controller.resize,
      onDragEnd: _controller.endDrag,
    );

    return UiSheet(
      onDismiss: _close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.translations.project_editor_eyebrow.toUpperCase(), style: UiTypography.eyebrow),
          UiSpacer.s,
          Text(
            state.isNew
                ? context.translations.project_editor_title_new
                : context.translations.project_editor_title_edit,
            style: UiTypography.headline,
          ),
          UiSpacer.xl,
          Text(context.translations.project_editor_name_label.toUpperCase(), style: UiTypography.cardLabel),
          UiSpacer.s,
          UiTextField(
            controller: _nameController,
            placeholder: context.translations.project_editor_name_placeholder,
            onChanged: _controller.setName,
          ),
          UiSpacer.xxl,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: UiSize.editorSourcesColumn,
                child: _SourcesColumn(
                  library: library,
                  placedKeys: state.placedKeys,
                  websiteController: _websiteController,
                  onAddWebsite: _addWebsite,
                  onCapture: _captureCurrentArrangement,
                ),
              ),
              const SizedBox(width: UiSize.xxl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.translations.project_editor_layout_label.toUpperCase(), style: UiTypography.cardLabel),
                    UiSpacer.m,
                    stage,
                    UiSpacer.m,
                    Text(
                      _captureFailed
                          ? context.translations.project_editor_capture_empty
                          : context.translations.project_editor_hint_drag,
                      style: UiTypography.hint.copyWith(color: _captureFailed ? UiColor.fgAccent : null),
                    ),
                    UiSpacer.xxs,
                    Text(context.translations.project_editor_hint_resize, style: UiTypography.hint),
                  ],
                ),
              ),
            ],
          ),
          UiSpacer.xxl,
          const SizedBox(height: 1, child: ColoredBox(color: UiColor.border)),
          UiSpacer.l,
          Row(
            children: [
              UiPrimaryButton(label: context.translations.common_save, onPressed: _save),
              UiSpacer.sm,
              UiGhostButton(label: context.translations.common_cancel, onPressed: _close),
              const Spacer(),
              if (!state.isNew)
                UiLinkLabel(
                  label: context.translations.common_delete,
                  color: UiColor.fgSubtle,
                  hoverColor: UiColor.fgAccent,
                  onTap: _delete,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourcesColumn extends ConsumerWidget {
  const _SourcesColumn({
    required this.library,
    required this.placedKeys,
    required this.websiteController,
    required this.onAddWebsite,
    required this.onCapture,
  });

  final List<AppLibraryEntry> library;
  final Set<String> placedKeys;
  final TextEditingController websiteController;
  final VoidCallback onAddWebsite;
  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(context.translations.project_editor_sources_label.toUpperCase(), style: UiTypography.cardLabel),
      UiSpacer.m,
      UiGhostButton(
        label: context.translations.project_editor_choose_from_finder,
        icon: const UiSvgIcon(path: UiIcon.folder, size: UiSize.l, color: UiColor.fgMuted),
        onPressed: () => _chooseFromFinder(ref),
      ),
      UiSpacer.s,
      // Arranging the real windows once and freezing them beats rebuilding the same
      // layout tile by tile.
      UiGhostButton(label: context.translations.project_editor_use_current_arrangement, onPressed: onCapture),
      UiSpacer.m,
      Row(
        children: [
          Expanded(
            child: UiTextField(
              controller: websiteController,
              placeholder: context.translations.project_editor_website_placeholder,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              onSubmitted: (_) => onAddWebsite(),
            ),
          ),
          UiSpacer.s,
          UiLinkLabel(label: context.translations.common_add, onTap: onAddWebsite),
        ],
      ),
      UiSpacer.m,
      Container(
        padding: const EdgeInsets.all(UiSize.m),
        decoration: BoxDecoration(color: UiColor.bgSubtle, borderRadius: UiRadius.allXl),
        child: Wrap(
          spacing: UiSize.xs,
          runSpacing: UiSize.xs,
          children: [for (final entry in library) _LibraryChip(entry: entry, isUsed: placedKeys.contains(entry.key))],
        ),
      ),
    ],
  );

  /// Opens the real `NSOpenPanel`; the chosen app joins the library as a chip.
  Future<void> _chooseFromFinder(WidgetRef ref) => ref.read(projectServiceProvider.notifier).chooseFromFinder();
}

class _LibraryChip extends StatelessWidget {
  const _LibraryChip({required this.entry, required this.isUsed});

  final AppLibraryEntry entry;
  final bool isUsed;

  @override
  Widget build(BuildContext context) {
    final chip = UiChip(label: entry.name, isUsed: isUsed);
    if (isUsed) return chip;

    return Draggable<AppLibraryEntry>(
      data: entry,
      feedback: Material(color: const Color(0x00000000), child: chip),
      childWhenDragging: Opacity(opacity: 0.4, child: chip),
      child: chip,
    );
  }
}
