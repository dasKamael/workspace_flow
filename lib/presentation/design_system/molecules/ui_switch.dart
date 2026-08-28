import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';

/// The 44×24 pill switch that arms the blocker.
class UiSwitch extends StatelessWidget {
  const UiSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    const inset = (UiSize.switchHeight - UiSize.switchKnob) / 2;

    return MouseRegion(
      cursor: onChanged == null ? MouseCursor.defer : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: AnimatedContainer(
          duration: UiMotion.fast,
          curve: UiMotion.ease,
          width: UiSize.switchWidth,
          height: UiSize.switchHeight,
          decoration: BoxDecoration(color: value ? UiColor.primary : UiColor.border, borderRadius: UiRadius.allFull),
          child: AnimatedAlign(
            duration: UiMotion.fast,
            curve: UiMotion.ease,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: inset),
              child: Container(
                width: UiSize.switchKnob,
                height: UiSize.switchKnob,
                decoration: const BoxDecoration(color: UiColor.white, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
