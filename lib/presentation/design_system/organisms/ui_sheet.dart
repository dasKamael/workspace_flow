import 'package:flutter/material.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_shadow.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';

/// A modal sheet over the window: scrim plus a panel that slides down into place.
///
/// The panel sits 36px from the top and is sized to fit without scrolling, as the
/// design requires.
class UiSheet extends StatefulWidget {
  const UiSheet({required this.child, required this.onDismiss, this.width = UiSize.sheetWide, super.key});

  final Widget child;

  /// Called when the scrim is clicked.
  final VoidCallback onDismiss;

  final double width;

  @override
  State<UiSheet> createState() => _UiSheetState();
}

class _UiSheetState extends State<UiSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: UiMotion.sheet)..forward();
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: UiMotion.ease);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => Stack(
      children: [
        // backdropIn
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            child: ColoredBox(color: UiColor.scrim.withValues(alpha: UiColor.scrim.a * _animation.value)),
          ),
        ),
        // sheetIn — translateY(-18px) + scale(0.985) to none
        Positioned(
          top: 36,
          left: 0,
          right: 0,
          child: Align(
            child: Transform.translate(
              offset: Offset(0, -18 * (1 - _animation.value)),
              child: Transform.scale(
                scale: 0.985 + 0.015 * _animation.value,
                child: Opacity(opacity: _animation.value, child: child),
              ),
            ),
          ),
        ),
      ],
    ),
    // A sheet is pushed as a transparent overlay route with no Scaffold above it, so
    // anything inside that expects a Material ancestor — a TextField, an InkWell —
    // would assert. Transparency keeps the panel's own decoration in charge.
    child: Material(
      type: MaterialType.transparency,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: UiSize.xxl),
        decoration: BoxDecoration(
          color: UiColor.white,
          borderRadius: UiRadius.allXxl,
          border: Border.all(color: UiColor.border),
          boxShadow: UiShadow.xl,
        ),
        child: widget.child,
      ),
    ),
  );
}
