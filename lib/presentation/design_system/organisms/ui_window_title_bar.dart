import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_icon.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';
import 'package:workspace_flow/presentation/design_system/molecules/ui_svg_icon.dart';

/// The 46px title bar with the centred mono title.
///
/// The traffic lights are the real macOS window buttons — the window runs with a hidden
/// title bar, so AppKit draws them on top of this strip. The left inset keeps the title
/// clear of them.
class UiWindowTitleBar extends StatelessWidget {
  const UiWindowTitleBar({required this.title, this.isSessionRunning = false, this.onSettingsTap, super.key});

  final String title;

  /// While a session runs the bar goes dark with the rest of the window.
  final bool isSessionRunning;

  /// Opens Settings. Left null while a session runs — a distraction-free view has no
  /// exit into anything else.
  final VoidCallback? onSettingsTap;

  /// Space reserved for the system's traffic-light buttons.
  static const double trafficLightInset = 78;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: UiMotion.slow,
    curve: UiMotion.ease,
    height: UiSize.titleBarHeight,
    decoration: BoxDecoration(
      color: isSessionRunning ? UiColor.bgDark : UiColor.white,
      border: Border(bottom: BorderSide(color: isSessionRunning ? UiColor.borderOnDarkSubtle : UiColor.border)),
    ),
    child: Row(
      children: [
        const SizedBox(width: trafficLightInset),
        Expanded(
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: UiMotion.slow,
              curve: UiMotion.ease,
              style: UiTypography.windowTitle.copyWith(
                color: isSessionRunning ? UiColor.onDarkAccent : UiColor.fgMuted,
              ),
              child: Text(title.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        SizedBox(
          width: trafficLightInset,
          child: onSettingsTap == null
              ? null
              : Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onSettingsTap,
                      child: UiSvgIcon(
                        path: UiIcon.cog6Tooth,
                        size: UiSize.l,
                        color: isSessionRunning ? UiColor.onDarkAccent : UiColor.fgMuted,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
