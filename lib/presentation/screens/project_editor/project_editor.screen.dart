import 'dart:typed_data';

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
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.state.dart';
import 'package:workspace_flow/presentation/screens/project_editor/widgets/window_selection_dialog.dart';

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

  /// Lets the user choose which of the windows open right now to freeze into the
  /// draft, rather than always taking every one of them.
  Future<void> _captureCurrentArrangement() async {
    final windows = await _controller.listOpenWindows();
    if (windows.isEmpty) {
      if (mounted) setState(() => _captureFailed = true);
      return;
    }
    if (!mounted) return;

    final selected = await showWindowSelectionDialog(context, windows: windows);
    if (selected == null || selected.isEmpty) return;

    final applied = await _controller.applySelectedWindows(selected);
    if (applied || !mounted) return;
    setState(() => _captureFailed = true);
  }

  /// The shared library, plus whatever this project's own windows use that the
  /// library no longer (or never did) list — so the panel never looks like it forgot
  /// an app the layout still visibly has.
  ///
  /// Every chip gets a × either way, but it means different things: for a library row
  /// it drops that entry from the shared pool; for a window-only chip — nothing backs
  /// it in the library — it drops the matching window from *this* project's draft,
  /// since that is the only thing its × could sensibly do.
  List<_LibraryRow> _combinedEntries(List<AppLibraryEntry> library, ProjectEditorState state, WidgetRef ref) {
    final rows = <_LibraryRow>[
      for (final entry in library)
        (entry: entry, onRemove: () => ref.read(projectServiceProvider.notifier).removeFromLibrary(entry)),
    ];
    final knownKeys = library.map((entry) => entry.key).toSet();

    for (final entry in state.windowEntries) {
      if (!knownKeys.add(entry.key)) continue;
      rows.add((entry: entry, onRemove: () => _controller.removeWindowsMatching(entry)));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectEditorControllerProvider(widget.projectId));
    final library = ref.watch(appLibraryProvider).value ?? const <AppLibraryEntry>[];
    final icons = ref.watch(appLibraryIconsProvider).value ?? const <String, Uint8List>{};

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
                  entries: _combinedEntries(library, state, ref),
                  icons: icons,
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

/// One chip in the "Apps & websites" panel: a library entry, or an app/site this
/// project's own windows use that the library no longer (or never did) list.
///
/// Only [removable] rows carry a × — there is nothing to remove for an entry that
/// exists purely because a window uses it; removing it wouldn't do anything to that
/// window anyway.
typedef _LibraryRow = ({AppLibraryEntry entry, VoidCallback onRemove});

/// Everything that answers "which apps and websites belong to this project".
class _SourcesColumn extends ConsumerWidget {
  const _SourcesColumn({
    required this.entries,
    required this.icons,
    required this.websiteController,
    required this.onAddWebsite,
    required this.captureFailed,
  });

  final List<_LibraryRow> entries;
  final Map<String, Uint8List> icons;
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
          // Pairs a folder with an app — "backend" — so a project window opens
          // showing the right project instead of a blank editor.
          UiGhostButton(
            label: context.translations.project_editor_add_project,
            icon: const UiSvgIcon(path: UiIcon.folder, size: UiSize.l, color: UiColor.fgMuted),
            onPressed: () => _addProjectFolder(ref),
          ),
        ],
      ),
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
          children: [
            for (final row in entries)
              UiChip(label: row.entry.name, icon: icons[row.entry.bundleId], onRemove: row.onRemove),
          ],
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

  /// Opens a folder picker and then an app picker, and joins the pair as a chip naming
  /// that specific project.
  Future<void> _addProjectFolder(WidgetRef ref) => ref.read(projectServiceProvider.notifier).addProjectFolder();
}
