import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// The 17px checkbox used by the workspace app rows and the blocker item rows.
///
/// When it becomes checked the tick plays `tickIn` — a short scale-in, keyed on
/// [checked] so it replays every time the value flips.
class UiTickBox extends StatelessWidget {
  const UiTickBox({required this.checked, this.onDark = false, super.key});

  final bool checked;

  /// Palette for the armed blocker card.
  final bool onDark;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: UiMotion.fast,
    curve: UiMotion.ease,
    width: UiSize.tickBox,
    height: UiSize.tickBox,
    decoration: BoxDecoration(
      color: checked ? UiColor.primary : const Color(0x00000000),
      borderRadius: UiRadius.allXs,
      border: checked ? null : Border.all(color: onDark ? UiColor.borderOnDark : UiColor.inactive),
    ),
    child: checked
        ? Center(
            child: _TickIn(
              key: ValueKey(checked),
              child: const UiSvgIcon(path: UiIcon.checkSolid, size: 11, color: UiColor.onDark, filled: true),
            ),
          )
        : null,
  );
}

/// `tickIn` — the tick scales in over 260ms.
class _TickIn extends StatefulWidget {
  const _TickIn({required this.child, super.key});

  final Widget child;

  @override
  State<_TickIn> createState() => _TickInState();
}

class _TickInState extends State<_TickIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.tickIn)..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: CurvedAnimation(parent: _controller, curve: UiMotion.ease).drive(Tween(begin: 0.4, end: 1)),
    child: FadeTransition(opacity: _controller, child: widget.child),
  );
}
