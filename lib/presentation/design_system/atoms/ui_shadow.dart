import 'package:flutter/painting.dart';

/// Elevation of the design system. Flat at rest, shadow on hover only.
///
/// The CSS values use `rgba(15,23,42,…)` — slate-900 at low opacity.
class UiShadow {
  UiShadow._();

  static const Color _base = Color(0xFF0F172A);

  /// `0 1px 2px 0 rgba(15,23,42,0.05)`
  static const List<BoxShadow> sm = [BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 1), blurRadius: 2)];

  /// `0 4px 6px -1px rgba(15,23,42,0.08), 0 2px 4px -2px rgba(15,23,42,0.06)`
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x140F172A), offset: Offset(0, 4), blurRadius: 6, spreadRadius: -1),
    BoxShadow(color: Color(0x0F0F172A), offset: Offset(0, 2), blurRadius: 4, spreadRadius: -2),
  ];

  /// `0 10px 15px -3px rgba(15,23,42,0.08), 0 4px 6px -4px rgba(15,23,42,0.05)`
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x140F172A), offset: Offset(0, 10), blurRadius: 15, spreadRadius: -3),
    BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 4), blurRadius: 6, spreadRadius: -4),
  ];

  /// `0 20px 25px -5px rgba(15,23,42,0.10), 0 8px 10px -6px rgba(15,23,42,0.05)`
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x1A0F172A), offset: Offset(0, 20), blurRadius: 25, spreadRadius: -5),
    BoxShadow(color: Color(0x0D0F172A), offset: Offset(0, 8), blurRadius: 10, spreadRadius: -6),
  ];

  /// Focus ring — `0 0 0 3px rgba(59,130,246,0.18)`.
  static const List<BoxShadow> focusRing = [BoxShadow(color: Color(0x2E3B82F6), spreadRadius: 3)];

  /// Guards against the unused-field lint while documenting the palette origin.
  static Color get baseColor => _base;
}
