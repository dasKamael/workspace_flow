import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/blocker/service/blocker_profile.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_fade_up.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
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
  final TextEditingController _websiteController = TextEditingController();
  final Map<int, TextEditingController> _entryControllers = {};
  bool _didPrefillName = false;

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
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

  /// Opens the Finder picker and appends the chosen app, with its bundle id, to the
  /// draft — its own separate control, so picking an app never blurs into typing a
  /// site.
  Future<void> _chooseApp() async {
    final entry = await ref.read(blockerProfileServiceProvider.notifier).pickApp();
    if (entry == null) return;
    _controller.addAppEntry(entry);
  }

  /// Adds a typed website from the bottom text field and clears it.
  void _addWebsite() {
    final raw = _websiteController.text;
    if (raw.trim().isEmpty) return;
    _websiteController.clear();
    _controller.addSiteEntry(raw);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileEditorControllerProvider(widget.profileId));
    final icons =
        ref.watch(blockerItemIconsProvider(state.items.map((item) => item.bundleId).toList())).value ??
        const <String, Uint8List>{};

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
          Text(context.translations.profile_editor_items_label.toUpperCase(), style: UiTypography.cardLabel),
          UiSpacer.m,
          for (final (index, item) in state.items.indexed) ...[
            UiFadeUp(
              key: ValueKey(item.id),
              duration: const Duration(milliseconds: 240),
              child: _EntryRow(
                controller: _entryController(item),
                kind: item.kind,
                icon: icons[item.bundleId],
                onChanged: (value) => _controller.setEntryName(index, value),
                onRemove: () => _controller.removeEntry(index),
              ),
            ),
            UiSpacer.s,
          ],
          UiSpacer.s,
          // Typing a site and picking an app are two distinct, un-mixed controls —
          // the field only ever adds a site; an app comes solely from Finder.
          Row(
            children: [
              Expanded(
                child: UiTextField(
                  controller: _websiteController,
                  placeholder: context.translations.profile_editor_website_placeholder,
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                  leading: const UiSvgIcon(path: UiIcon.globeAlt, size: UiSize.l, color: UiColor.fgSubtle),
                  onSubmitted: (_) => _addWebsite(),
                ),
              ),
              UiSpacer.s,
              UiLinkLabel(label: context.translations.common_add, onTap: _addWebsite),
            ],
          ),
          UiSpacer.m,
          UiGhostButton(
            label: context.translations.profile_editor_choose_app,
            icon: const UiSvgIcon(path: UiIcon.squares2x2, size: UiSize.l, color: UiColor.fgMuted),
            onPressed: _chooseApp,
          ),
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
    required this.icon,
    required this.onChanged,
    required this.onRemove,
  });

  final TextEditingController controller;
  final BlockedItemKind kind;

  /// The real app icon, keyed by bundle id — null for sites, and for an app entry
  /// while its icon is still loading.
  final Uint8List? icon;

  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: UiTextField(
          controller: controller,
          placeholder: context.translations.profile_editor_entry_placeholder,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          leading: switch (icon) {
            final Uint8List bytes => Image.memory(
              bytes,
              width: UiSize.l,
              height: UiSize.l,
              filterQuality: FilterQuality.medium,
            ),
            null => UiSvgIcon(
              path: kind == BlockedItemKind.site ? UiIcon.globeAlt : UiIcon.squares2x2,
              size: UiSize.l,
              color: UiColor.fgSubtle,
            ),
          },
          onChanged: onChanged,
        ),
      ),
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
