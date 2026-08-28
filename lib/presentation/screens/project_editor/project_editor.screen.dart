import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
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

  /// Opens the full-size overlay on the real screens.
  Future<void> _arrangeOnScreen() => _controller.arrangeOnScreen();

  /// Freezes the windows that are open right now into the draft.
  Future<void> _captureCurrentArrangement() async {
    final captured = await _controller.captureCurrentArrangement();
    if (captured || !mounted) return;
    setState(() => _captureFailed = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectEditorControllerProvider(widget.projectId));
    final library = ref.watch(appLibraryProvider).valueOrNull ?? const <AppLibraryEntry>[];

    if (state.isLoaded && !_didPrefillName) {
      _didPrefillName = true;
      _nameController.text = state.name;
    }

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
              // Arranging is its own concern: it decides where windows go, not which
              // apps a project contains.
              SizedBox(
                width: UiSize.editorSourcesColumn,
                child: _LayoutColumn(onCapture: _captureCurrentArrangement, onArrangeOnScreen: _arrangeOnScreen),
              ),
              const SizedBox(width: UiSize.xxl),
              Expanded(
                child: _SourcesColumn(
                  library: library,
                  websiteController: _websiteController,
                  onAddWebsite: _addWebsite,
                  captureFailed: _captureFailed,
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

/// The two ways to settle where windows go.
class _LayoutColumn extends StatelessWidget {
  const _LayoutColumn({required this.onCapture, required this.onArrangeOnScreen});

  final VoidCallback onCapture;
  final VoidCallback onArrangeOnScreen;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(context.translations.project_editor_layout_label.toUpperCase(), style: UiTypography.cardLabel),
      UiSpacer.m,
      // The stage is a miniature; this puts the same tiles on the real screens at real
      // size, where one can judge how big a window will be.
      UiGhostButton(label: context.translations.project_editor_arrange_on_screen, onPressed: onArrangeOnScreen),
      UiSpacer.s,
      // Arranging the real windows once and freezing them beats rebuilding the same
      // layout tile by tile.
      UiGhostButton(label: context.translations.project_editor_use_current_arrangement, onPressed: onCapture),
    ],
  );
}

/// Everything that answers "which apps and websites belong to this project".
class _SourcesColumn extends ConsumerWidget {
  const _SourcesColumn({
    required this.library,
    required this.websiteController,
    required this.onAddWebsite,
    required this.captureFailed,
  });

  final List<AppLibraryEntry> library;
  final TextEditingController websiteController;
  final VoidCallback onAddWebsite;

  /// Set when capturing found nothing, so the hint can explain why.
  final bool captureFailed;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(context.translations.project_editor_sources_label.toUpperCase(), style: UiTypography.cardLabel),
      UiSpacer.m,
      Row(
        children: [
          UiGhostButton(
            label: context.translations.project_editor_choose_from_finder,
            icon: const UiSvgIcon(path: UiIcon.folder, size: UiSize.l, color: UiColor.fgMuted),
            onPressed: () => _chooseFromFinder(ref),
          ),
          UiSpacer.m,
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
          children: [for (final entry in library) UiChip(label: entry.name)],
        ),
      ),
      UiSpacer.m,
      Text(
        captureFailed
            ? context.translations.project_editor_capture_empty
            : context.translations.project_editor_library_hint,
        style: UiTypography.hint.copyWith(color: captureFailed ? UiColor.fgAccent : null),
      ),
    ],
  );

  /// Opens the real `NSOpenPanel`; the chosen app joins the library as a chip.
  Future<void> _chooseFromFinder(WidgetRef ref) => ref.read(projectServiceProvider.notifier).chooseFromFinder();
}
