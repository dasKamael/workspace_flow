/// Icon path data, in the Heroicons style used by the design.
///
/// Outline icons use `viewBox 0 0 24 24` with `stroke-width 1.5–2`; the solid check
/// uses `viewBox 0 0 20 20` and is filled. The paths are copied verbatim from Heroicons
/// and turned into a [Path] by `SvgPathUtil`.
class UiIcon {
  UiIcon._();

  /// View box of the outline icons.
  static const double outlineViewBox = 24;

  /// View box of the solid icons.
  static const double solidViewBox = 20;

  /// Default stroke width of an outline icon, in view-box units.
  static const double outlineStrokeWidth = 1.5;

  /// `check` (solid, 20) — the tick inside a checked box.
  static const String checkSolid =
      'M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 '
      '011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z';

  /// `folder` (outline, 24) — "Choose from Finder…".
  static const String folder =
      'M2.25 12.75V12A2.25 2.25 0 014.5 9.75h15A2.25 2.25 0 0121.75 12v.75m-8.69-6.44l-2.12-2.12a1.5 '
      '1.5 0 00-1.061-.44H4.5A2.25 2.25 0 002.25 6v12a2.25 2.25 0 002.25 2.25h15A2.25 2.25 0 '
      '0021.75 18V9a2.25 2.25 0 00-2.25-2.25h-5.379a1.5 1.5 0 01-1.06-.44z';

  /// `no-symbol` (outline, 24) — the blocked page.
  static const String noSymbol =
      'M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 '
      '5.636m12.728 12.728L5.636 5.636';

  /// `lock-closed` shackle (outline, 24) — animated separately in the arming sequence.
  static const String lockShackle = 'M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75';

  /// `lock-closed` body (outline, 24).
  static const String lockBody =
      'M6.75 21.75h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 '
      '00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z';

  /// `x-mark` (outline, 24) — remove buttons.
  static const String xMark = 'M6 18L18 6M6 6l12 12';

  /// `plus` (outline, 24).
  static const String plus = 'M12 4.5v15m7.5-7.5h-15';

  /// `pencil` (outline, 24) — edit the selected blocker profile.
  static const String pencil =
      'M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z';
}
