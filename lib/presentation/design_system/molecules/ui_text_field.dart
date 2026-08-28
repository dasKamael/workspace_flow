import 'package:flutter/material.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_shadow.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';

/// A mono text input with the design's focus ring.
class UiTextField extends StatefulWidget {
  const UiTextField({
    required this.controller,
    this.placeholder,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    super.key,
  });

  final TextEditingController controller;
  final String? placeholder;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool autofocus;
  final EdgeInsets padding;

  @override
  State<UiTextField> createState() => _UiTextFieldState();
}

class _UiTextFieldState extends State<UiTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _hasFocus = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: UiMotion.fast,
    curve: UiMotion.ease,
    decoration: BoxDecoration(
      color: UiColor.white,
      borderRadius: UiRadius.allM,
      border: Border.all(color: _hasFocus ? UiColor.accent : UiColor.border),
      boxShadow: _hasFocus ? UiShadow.focusRing : const [],
    ),
    padding: widget.padding,
    // The editors are transparent overlay routes with no Scaffold, and TextField
    // insists on a Material ancestor. The field paints its own background above.
    child: Material(
      type: MaterialType.transparency,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
        cursorHeight: UiSize.ml,
        style: UiTypography.input,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: widget.placeholder,
          hintStyle: UiTypography.inputPlaceholder,
        ),
      ),
    ),
  );
}
