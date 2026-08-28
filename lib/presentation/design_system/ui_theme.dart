import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_radius.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';

part 'ui_theme.g.dart';

/// The app's Material theme.
///
/// The design is light-only: the dark surfaces (armed blocker card, running session)
/// are component variants using `UiColor.onDark*`, not a second theme. Screens should
/// read `UiColor.x` directly and only fall back to `Theme.of(context)` where a Material
/// widget insists on it.
class UiTheme {
  const UiTheme();

  ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      primary: UiColor.primary,
      onPrimary: UiColor.onDark,
      primaryContainer: UiColor.bgAccent,
      onPrimaryContainer: UiColor.fgAccentHover,
      secondary: UiColor.accent,
      onSecondary: UiColor.onDark,
      surface: UiColor.bg,
      onSurface: UiColor.fgStrong,
      surfaceContainerLowest: UiColor.bg,
      surfaceContainerLow: UiColor.bgSubtle,
      surfaceContainer: UiColor.bgMuted,
      onSurfaceVariant: UiColor.fgMuted,
      outline: UiColor.border,
      outlineVariant: UiColor.borderStrong,
      scrim: UiColor.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: UiColor.bgSubtle,
      canvasColor: UiColor.bg,
      fontFamily: UiTypography.fontSans,
      textTheme: UiTypography.textTheme,
      splashFactory: NoSplash.splashFactory,
      // The design has no ripples — feedback is a hover lift plus a shadow.
      highlightColor: Colors.transparent,
      dividerTheme: const DividerThemeData(color: UiColor.border, thickness: 1, space: 1),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: UiColor.primary,
        selectionColor: UiColor.bgAccentStrong,
        selectionHandleColor: UiColor.primary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(color: UiColor.bgDark, borderRadius: UiRadius.allM),
        textStyle: UiTypography.mono(size: 11, color: UiColor.onDark),
      ),
    );
  }
}

@Riverpod(keepAlive: true)
UiTheme uiTheme(Ref ref) => const UiTheme();
