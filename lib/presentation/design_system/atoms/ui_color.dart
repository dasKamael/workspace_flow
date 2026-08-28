import 'package:flutter/painting.dart';
import 'package:workspace_flow/presentation/design_system/atoms/colors/brand.color_palette.dart';
import 'package:workspace_flow/presentation/design_system/atoms/colors/slate.color_palette.dart';

/// Semantic colour roles of the design system.
///
/// Always use `UiColor.x` in screens and components; reach for
/// `Theme.of(context).colorScheme` only where a Material widget demands it.
///
/// The app has a single (light) theme. The dark surfaces in the design — the armed
/// blocker card and the running-session view — are *component* variants, not a theme
/// switch, and use the `onDark*` roles below.
class UiColor {
  UiColor._();

  // ---------------------------------------------------------------- Surfaces
  /// Page base — white-first.
  static const Color bg = white;

  /// Window body, alternating sections.
  static const Color bgSubtle = SlateColorPalette.shade50;

  /// Inner panels, hover surfaces.
  static const Color bgMuted = SlateColorPalette.shade100;

  /// Dark surfaces (armed blocker, focus session).
  static const Color bgDark = BrandColorPalette.shade950;

  /// Tinted surface for selected/active items.
  static const Color bgAccent = BrandColorPalette.shade50;

  /// Stronger tinted surface (selected window tile).
  static const Color bgAccentStrong = BrandColorPalette.shade100;

  static const Color white = Color(0xFFFFFFFF);

  // ------------------------------------------------------------ Foregrounds
  /// Body copy.
  static const Color fg = SlateColorPalette.shade700;

  /// Headings, project names.
  static const Color fgStrong = SlateColorPalette.shade900;

  /// Card body text.
  static const Color fgBody = SlateColorPalette.shade800;

  /// Subtitles, secondary text.
  static const Color fgMuted = SlateColorPalette.shade500;

  /// Labels, placeholders, captions.
  static const Color fgSubtle = SlateColorPalette.shade400;

  /// Disabled text, inactive state text.
  static const Color fgDisabled = SlateColorPalette.shade300;

  /// Links, eyebrows.
  static const Color fgAccent = BrandColorPalette.shade600;

  /// Link hover.
  static const Color fgAccentHover = BrandColorPalette.shade800;

  // -------------------------------------------------------- On dark surfaces
  static const Color onDark = white;
  static const Color onDarkStrong = Color(0xD9FFFFFF); // rgba(255,255,255,0.85)
  static const Color onDarkMuted = Color(0x59FFFFFF); // rgba(255,255,255,0.35)
  static const Color onDarkSubtle = Color(0xB3FFFFFF); // rgba(255,255,255,0.70)
  static const Color onDarkAccent = BrandColorPalette.shade400;

  // ---------------------------------------------------------------- Borders
  static const Color border = SlateColorPalette.shade200;
  static const Color borderStrong = SlateColorPalette.shade300;
  static const Color borderAccent = BrandColorPalette.shade200;
  static const Color borderAccentStrong = BrandColorPalette.shade300;

  /// Borders on dark surfaces — rgba(255,255,255,0.12).
  static const Color borderOnDark = Color(0x1FFFFFFF);

  /// Title-bar divider while a session runs — rgba(255,255,255,0.08).
  static const Color borderOnDarkSubtle = Color(0x14FFFFFF);

  /// STOP button border — rgba(255,255,255,0.16).
  static const Color borderOnDarkButton = Color(0x29FFFFFF);

  /// STOP button border on hover — rgba(255,255,255,0.40).
  static const Color borderOnDarkButtonHover = Color(0x66FFFFFF);

  /// Progress-ring track on dark — rgba(255,255,255,0.10).
  static const Color trackOnDark = Color(0x1AFFFFFF);

  // ---------------------------------------------------------------- Actions
  static const Color primary = BrandColorPalette.shade600;
  static const Color primaryHover = BrandColorPalette.shade700;
  static const Color primaryActive = BrandColorPalette.shade800;

  /// Launch button once the workspace has been launched.
  static const Color primaryDone = SlateColorPalette.shade400;

  /// Progress fills, sweeps, active tick marks.
  static const Color accent = BrandColorPalette.shade500;

  /// Progress-bar track.
  static const Color track = SlateColorPalette.shade100;

  /// Inactive tick marks, inactive status dot.
  static const Color inactive = SlateColorPalette.shade300;

  /// Focus ring — rgba(59,130,246,0.18), used as a 3px outer glow.
  static const Color focusRing = Color(0x2E3B82F6);

  /// Overlay behind a sheet — rgba(15,23,42,0.40).
  static const Color scrim = Color(0x660F172A);

  /// Overlay behind the Finder picker — rgba(15,23,42,0.45).
  static const Color scrimStrong = Color(0x730F172A);

  /// Icon chip on the blocked page — rgba(37,99,235,0.20).
  static const Color accentChipOnDark = Color(0x332563EB);
}
