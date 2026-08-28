import 'package:flutter/widgets.dart';

/// Rebuilds [builder] with the current hover state.
///
/// The design gives almost everything a hover treatment — a lift, a shadow, a colour
/// change — so this keeps the `MouseRegion` plus `setState` boilerplate in one place.
class UiHoverRegion extends StatefulWidget {
  const UiHoverRegion({required this.builder, this.cursor = SystemMouseCursors.click, this.enabled = true, super.key});

  final Widget Function(BuildContext context, bool isHovered) builder;
  final MouseCursor cursor;

  /// When false the region reports "not hovered" and shows the basic cursor.
  final bool enabled;

  @override
  State<UiHoverRegion> createState() => _UiHoverRegionState();
}

class _UiHoverRegionState extends State<UiHoverRegion> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    cursor: widget.enabled ? widget.cursor : MouseCursor.defer,
    onEnter: widget.enabled ? (_) => setState(() => _isHovered = true) : null,
    onExit: widget.enabled ? (_) => setState(() => _isHovered = false) : null,
    child: widget.builder(context, widget.enabled && _isHovered),
  );
}
