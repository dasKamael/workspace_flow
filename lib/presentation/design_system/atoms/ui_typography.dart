import 'package:flutter/material.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';

/// Typography of the design system.
///
/// Two families: **JetBrains Mono** for headlines, labels, buttons and every numeral,
/// **Inter** for body copy. CSS letter-spacing is given in `em`; Flutter wants absolute
/// logical pixels, so every value below is `fontSize * em`.
///
/// The getters are deliberately not `const` so hot reload picks up changes.
class UiTypography {
  UiTypography._();

  static const String fontDisplay = 'JetBrains Mono';
  static const String fontMono = 'JetBrains Mono';
  static const String fontSans = 'Inter';

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  /// Base builder for a monospace style. [tracking] is in `em`.
  static TextStyle mono({
    required double size,
    FontWeight weight = regular,
    Color color = UiColor.fg,
    double tracking = 0,
    double? height,
    bool tabularNums = false,
  }) => TextStyle(
    fontFamily: fontMono,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: size * tracking,
    height: height,
    fontFeatures: tabularNums ? _tabular : null,
  );

  /// Base builder for a body (Inter) style.
  static TextStyle sans({
    required double size,
    FontWeight weight = regular,
    Color color = UiColor.fg,
    double? height,
  }) => TextStyle(fontFamily: fontSans, fontSize: size, fontWeight: weight, color: color, height: height);

  // ------------------------------------------------------------- Window chrome
  /// Window title — 12 / 700, 0.1em, uppercase.
  static TextStyle get windowTitle => mono(size: 12, weight: bold, tracking: 0.1, color: UiColor.fgMuted);

  // ------------------------------------------------------------------- Labels
  /// Card label ("PROJECTS", "APP BLOCKER") — 10 / 700, 0.15em, uppercase.
  static TextStyle get cardLabel => mono(size: 10, weight: bold, tracking: 0.15, color: UiColor.fgSubtle);

  /// Inline link label ("+ NEW", "EDIT") — 10 / 700, 0.15em, uppercase.
  static TextStyle get linkLabel => mono(size: 10, weight: bold, tracking: 0.15, color: UiColor.fgAccent);

  /// Muted inline link ("EDIT" on a project row) — 10 / 700, uppercase.
  static TextStyle get linkLabelMuted => mono(size: 10, weight: bold, tracking: 0.15, color: UiColor.fgSubtle);

  /// Sheet eyebrow ("SETTINGS · PROJECT") — 12 / 700, 0.15em, uppercase.
  static TextStyle get eyebrow => mono(size: 12, weight: bold, tracking: 0.15, color: UiColor.fgAccent);

  /// Footer action ("DELETE") — 10.5 / 700, uppercase.
  static TextStyle get footerAction => mono(size: 10.5, weight: bold, tracking: 0.1, color: UiColor.fgSubtle);

  // ---------------------------------------------------------------- Headlines
  /// Sheet and workspace headline — 22 / 800, -0.02em.
  static TextStyle get headline => mono(size: 22, weight: extraBold, tracking: -0.02, color: UiColor.fgStrong);

  /// Blocked page headline — 28 / 800, -0.02em, on dark.
  static TextStyle get headlineOnDark => mono(size: 28, weight: extraBold, tracking: -0.02, color: UiColor.onDark);

  // ------------------------------------------------------------------ Buttons
  /// Primary and ghost button label — 11 / 700, 0.1em, uppercase.
  static TextStyle get button => mono(size: 11, weight: bold, tracking: 0.1, color: UiColor.onDark);

  /// Preset button label — 11 / 700, uppercase.
  static TextStyle get preset => mono(size: 11, weight: bold, tracking: 0.1, color: UiColor.fg);

  // ------------------------------------------------------------------- Lists
  /// Project name on a card — 14 / 700.
  static TextStyle get itemTitle => mono(size: 14, weight: bold, color: UiColor.fgStrong);

  /// Project subtitle ("3 apps · saved layout") — 11.
  static TextStyle get itemSubtitle => mono(size: 11, color: UiColor.fgSubtle);

  /// App name in the workspace list — Inter 13.5.
  static TextStyle get appName => sans(size: 13.5, color: UiColor.fgBody);

  /// State text of an app row ("opening…", "open") — 10.5.
  static TextStyle get rowState => mono(size: 10.5, color: UiColor.fgSubtle);

  /// Blocker item name — 12.5.
  static TextStyle get blockerItem => mono(size: 12.5, color: UiColor.fgBody);

  /// Blocker item kind ("site" / "app") — 10.5.
  static TextStyle get blockerKind => mono(size: 10.5, color: UiColor.fgSubtle);

  /// Library chip — Inter 11.5.
  static TextStyle get chip => sans(size: 11.5, color: UiColor.fg);

  // ------------------------------------------------------------------- Values
  /// Dial centre value — 34 / 700, tabular.
  static TextStyle get dialValue =>
      mono(size: 34, weight: bold, color: UiColor.fgStrong, tabularNums: true, height: 1.0);

  /// Dial meta line ("ends 10:28") — 11.5.
  static TextStyle get dialMeta => mono(size: 11.5, color: UiColor.fgSubtle);

  /// Running-session countdown — 72 / 700, tabular, white.
  static TextStyle get sessionValue =>
      mono(size: 72, weight: bold, color: UiColor.onDark, tabularNums: true, height: 1.0);

  /// "IN FOCUS" badge — 11 / 700, 0.2em, uppercase.
  static TextStyle get sessionBadge => mono(size: 11, weight: bold, tracking: 0.2, color: UiColor.onDarkAccent);

  /// "Blocked today" count — 28 / 700, tabular.
  static TextStyle get statValue => mono(size: 28, weight: bold, color: UiColor.fgStrong, tabularNums: true);

  /// Stats line under the start button — 11.5.
  static TextStyle get statLine => mono(size: 11.5, color: UiColor.fgSubtle);

  // ------------------------------------------------------------------ Editor
  /// Window tile name — 11.5 / 700.
  static TextStyle get tileName => mono(size: 11.5, weight: bold, color: UiColor.fgStrong);

  /// Window tile size readout ("62×100") — 10.
  static TextStyle get tileSize => mono(size: 10, color: UiColor.fgSubtle);

  /// Monitor caption ("Monitor 1 · 27″") — 10.
  static TextStyle get monitorCaption => mono(size: 10, color: UiColor.fgSubtle);

  /// Text field content — 12.5.
  static TextStyle get input => mono(size: 12.5, color: UiColor.fgBody);

  /// Text field placeholder — 12.5.
  static TextStyle get inputPlaceholder => mono(size: 12.5, color: UiColor.fgSubtle);

  // -------------------------------------------------------------------- Body
  /// Footer hint and small print — Inter 14.
  static TextStyle get body => sans(size: 14, color: UiColor.fgMuted, height: 1.5);

  /// Caption under a stat tile — Inter 13.
  static TextStyle get caption => sans(size: 13, color: UiColor.fgMuted, height: 1.5);

  /// Hint lines under the monitor stage — Inter 13.
  static TextStyle get hint => sans(size: 13, color: UiColor.fgMuted, height: 1.5);

  /// Material [TextTheme] so plain Material widgets pick up the right families.
  static TextTheme get textTheme => TextTheme(
    displayLarge: sessionValue,
    displayMedium: statValue,
    headlineLarge: headline,
    headlineMedium: mono(size: 18, weight: bold, color: UiColor.fgStrong, tracking: -0.02),
    titleLarge: itemTitle,
    titleMedium: mono(size: 12.5, weight: bold, color: UiColor.fgStrong),
    bodyLarge: sans(size: 14, color: UiColor.fg, height: 1.5),
    bodyMedium: body,
    bodySmall: caption,
    labelLarge: button,
    labelMedium: cardLabel,
    labelSmall: rowState,
  );
}
