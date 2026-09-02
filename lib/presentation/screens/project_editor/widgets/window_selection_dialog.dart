import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/common/translation/translation.extension.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/domain/system/app_icons.util.dart';
import 'package:workspace_flow/domain/system/model/captured_window.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_spacer.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_ghost_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_hover_region.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_primary_button.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_tick_box.dart';
import 'package:workspace_flow/presentation/design_system/organisms/ui_sheet.dart';

/// Lets the user pick which of the windows open right now should become the
/// project's layout, instead of always taking every one of them.
///
/// Returns the windows left checked, or null when the sheet was dismissed.
Future<List<CapturedWindow>?> showWindowSelectionDialog(
  BuildContext context, {
  required List<CapturedWindow> windows,
}) => showGeneralDialog<List<CapturedWindow>>(
  context: context,
  barrierLabel: 'Select windows',
  // UiSheet paints its own scrim, so the barrier itself stays invisible.
  barrierColor: const Color(0x00000000),
  transitionDuration: Duration.zero,
  pageBuilder: (context, _, _) => _WindowSelectionDialog(windows: windows),
);

class _WindowSelectionDialog extends ConsumerStatefulWidget {
  const _WindowSelectionDialog({required this.windows});

  final List<CapturedWindow> windows;

  @override
  ConsumerState<_WindowSelectionDialog> createState() => _WindowSelectionDialogState();
}

class _WindowSelectionDialogState extends ConsumerState<_WindowSelectionDialog> {
  // Every window starts checked — picking is normally about excluding the odd one,
  // not building the set back up from nothing.
  late final Set<int> _selected = {for (var i = 0; i < widget.windows.length; i++) i};

  Map<String, Uint8List> _icons = const {};

  @override
  void initState() {
    super.initState();
    _loadIcons();
  }

  Future<void> _loadIcons() async {
    final icons = await AppIconsUtil.fetch(
      ref.read(appLauncherRepositoryProvider),
      widget.windows.map((window) => window.bundleId),
    );
    if (mounted) setState(() => _icons = icons);
  }

  void _toggle(int index) => setState(() {
    if (!_selected.remove(index)) _selected.add(index);
  });

  void _confirm() =>
      Navigator.of(context).pop([for (final (index, window) in widget.windows.indexed) if (_selected.contains(index)) window]);

  void _cancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) => UiSheet(
    onDismiss: _cancel,
    width: UiSize.sheetNarrow,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.translations.window_selection_eyebrow.toUpperCase(), style: UiTypography.eyebrow),
        UiSpacer.s,
        Text(context.translations.window_selection_title, style: UiTypography.headline),
        UiSpacer.l,
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (final (index, window) in widget.windows.indexed)
                  _WindowRow(
                    window: window,
                    icon: _icons[window.bundleId],
                    checked: _selected.contains(index),
                    onTap: () => _toggle(index),
                  ),
              ],
            ),
          ),
        ),
        UiSpacer.xl,
        Row(
          children: [
            UiPrimaryButton(
              label: context.translations.window_selection_confirm(_selected.length),
              onPressed: _selected.isEmpty ? null : _confirm,
            ),
            UiSpacer.sm,
            UiGhostButton(label: context.translations.common_cancel, onPressed: _cancel),
          ],
        ),
      ],
    ),
  );
}

/// One selectable window: tick box, icon, app name.
class _WindowRow extends StatelessWidget {
  const _WindowRow({required this.window, required this.icon, required this.checked, required this.onTap});

  final CapturedWindow window;
  final Uint8List? icon;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => UiHoverRegion(
    builder: (context, isHovered) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: UiMotion.fast,
        curve: UiMotion.ease,
        padding: const EdgeInsets.symmetric(horizontal: UiSize.xs, vertical: UiSize.s),
        decoration: BoxDecoration(color: isHovered ? UiColor.bgSubtle : UiColor.white, borderRadius: UiRadius.allM),
        child: Row(
          children: [
            UiTickBox(checked: checked),
            const SizedBox(width: UiSize.m),
            if (icon != null) ...[
              Image.memory(icon!, width: UiSize.l, height: UiSize.l, filterQuality: FilterQuality.medium),
              const SizedBox(width: UiSize.s),
            ],
            Expanded(
              // The window's own title — "app-backend" — leads, since the app name
              // alone ("Code") cannot tell two windows of the same app apart. Falls
              // back to the app name for windows that report no title of their own.
              child: Text(
                window.windowTitle.isEmpty ? window.name : window.windowTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: UiTypography.appName,
              ),
            ),
            if (window.windowTitle.isNotEmpty && window.windowTitle != window.name) ...[
              const SizedBox(width: UiSize.s),
              Text(window.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: UiTypography.rowState),
            ],
          ],
        ),
      ),
    ),
  );
}
