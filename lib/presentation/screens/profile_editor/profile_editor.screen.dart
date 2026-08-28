import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_fade_up.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_link_label.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_text_field.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_sheet.dart';
import 'package:workspace_flow/presentation/router.dart';
import 'package:workspace_flow/presentation/screens/profile_editor/profile_editor.controller.dart';

/// The blocker profile editor sheet — name plus a list of blocked entries.
class ProfileEditorScreen extends ConsumerStatefulWidget {
  const ProfileEditorScreen({required this.profileId, super.key});

  /// Null when creating a new profile.
  final int? profileId;

  @override
  ConsumerState<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends ConsumerState<ProfileEditorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final Map<int, TextEditingController> _entryControllers = {};
  bool _didPrefillName = false;

  @override
  void dispose() {
    _nameController.dispose();
    for (final controller in _entryControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  ProfileEditorController get _controller => ref.read(profileEditorControllerProvider(widget.profileId).notifier);

  void _close() => context.goNamed(UiRoute.workspace.name);

  Future<void> _save() async {
    await _controller.save(fallbackName: context.translations.profile_editor_untitled);
    if (mounted) _close();
  }

  Future<void> _delete() async {
    await _controller.delete();
    if (mounted) _close();
  }

  /// One controller per row, keyed by the draft id so rows keep their text when the
  /// list around them changes.
  TextEditingController _entryController(BlockedItem item) =>
      _entryControllers.putIfAbsent(item.id, () => TextEditingController(text: item.name));

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditorControllerProvider(widget.profileId));

    if (state.isLoaded && !_didPrefillName) {
      _didPrefillName = true;
      _nameController.text = state.name;
    }

    return UiSheet(
      width: UiSize.sheetNarrow,
      onDismiss: _close,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.translations.profile_editor_eyebrow.toUpperCase(), style: UiTypography.eyebrow),
          UiSpacer.s,
          Text(
            state.isNew
                ? context.translations.profile_editor_title_new
                : context.translations.profile_editor_title_edit,
            style: UiTypography.headline,
          ),
          UiSpacer.xl,
          Text(context.translations.profile_editor_name_label.toUpperCase(), style: UiTypography.cardLabel),
          UiSpacer.s,
          UiTextField(
            controller: _nameController,
            placeholder: context.translations.profile_editor_name_placeholder,
            onChanged: _controller.setName,
          ),
          UiSpacer.xxl,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.translations.profile_editor_items_label.toUpperCase(), style: UiTypography.cardLabel),
              UiLinkLabel(label: context.translations.profile_editor_add_entry, onTap: _controller.addEntry),
            ],
          ),
          UiSpacer.m,
          for (final (index, item) in state.items.indexed) ...[
            UiFadeUp(
              key: ValueKey(item.id),
              duration: const Duration(milliseconds: 240),
              child: _EntryRow(
                controller: _entryController(item),
                kind: item.kind,
                onChanged: (value) => _controller.setEntryName(index, value),
                onToggleKind: () => _controller.toggleKind(index),
                onRemove: () => _controller.removeEntry(index),
              ),
            ),
            UiSpacer.s,
          ],
          UiSpacer.l,
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
                  // Blocked while this is the only profile left.
                  onTap: state.canDelete ? _delete : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.controller,
    required this.kind,
    required this.onChanged,
    required this.onToggleKind,
    required this.onRemove,
  });

  final TextEditingController controller;
  final BlockedItemKind kind;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleKind;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: UiTextField(
          controller: controller,
          placeholder: context.translations.profile_editor_entry_placeholder,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          onChanged: onChanged,
        ),
      ),
      UiSpacer.s,
      _KindPill(kind: kind, onTap: onToggleKind),
      UiSpacer.s,
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onRemove,
          child: const SizedBox.square(
            dimension: UiSize.xl,
            child: Center(
              child: UiSvgIcon(path: UiIcon.xMark, size: 12, color: UiColor.fgSubtle, strokeWidth: 2),
            ),
          ),
        ),
      ),
    ],
  );
}

/// The pill that flips a row between "site" and "app".
class _KindPill extends StatelessWidget {
  const _KindPill({required this.kind, required this.onTap});

  final BlockedItemKind kind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSite = kind == BlockedItemKind.site;

    return UiHoverRegion(
      builder: (context, isHovered) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: UiSize.m, vertical: UiSize.xs),
          decoration: BoxDecoration(
            color: isSite ? UiColor.bgAccent : UiColor.bgMuted,
            borderRadius: UiRadius.allFull,
            border: Border.all(color: isHovered ? UiColor.borderStrong : UiColor.border),
          ),
          child: Text(
            isSite ? context.translations.common_kind_site : context.translations.common_kind_app,
            style: UiTypography.blockerKind.copyWith(color: isSite ? UiColor.fgAccentHover : UiColor.fgMuted),
          ),
        ),
      ),
    );
  }
}
