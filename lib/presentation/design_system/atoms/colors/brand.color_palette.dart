// coverage:ignore-file
import 'package:flutter/painting.dart';

/// App-Care brand blue — the only accent, used at varying intensities.
///
/// Source: `design_handoff_focus_app/_ds/.../colors_and_type.css`.
class BrandColorPalette {
  BrandColorPalette._();

  /// Backgrounds, hover surfaces.
  static const Color shade50 = Color(0xFFEFF6FF);

  /// Badges, tint surfaces.
  static const Color shade100 = Color(0xFFDBEAFE);

  /// Borders.
  static const Color shade200 = Color(0xFFBFDBFE);

  /// Decorative.
  static const Color shade300 = Color(0xFF93C5FD);

  /// Links hover, accents on dark surfaces.
  static const Color shade400 = Color(0xFF60A5FA);

  /// Secondary links, focus ring.
  static const Color shade500 = Color(0xFF3B82F6);

  /// PRIMARY — CTAs, buttons, main brand color.
  static const Color shade600 = Color(0xFF2563EB);

  /// Hover state.
  static const Color shade700 = Color(0xFF1D4ED8);

  /// Active state, deep accents.
  static const Color shade800 = Color(0xFF1E40AF);

  /// Dark text.
  static const Color shade900 = Color(0xFF1E3A8A);

  /// Dark surfaces — never black or grey.
  static const Color shade950 = Color(0xFF172554);
}
