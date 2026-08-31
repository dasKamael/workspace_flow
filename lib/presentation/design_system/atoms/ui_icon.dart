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

  /// `globe-alt` (outline, 24) — a "site" entry, in the blocker.
  static const String globeAlt =
      'M12 21a9.004 9.004 0 008.716-6.747M12 21a9.004 9.004 0 01-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 '
      '3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 017.843 4.582M12 3a8.997 8.997 0 '
      '00-7.843 4.582m15.686 0A11.953 11.953 0 0112 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 '
      '0121 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0112 16.5c-3.162 0-6.133-.815-8.716-2.247m0 '
      '0A9.015 9.015 0 013 12c0-1.605.42-3.113 1.157-4.418';

  /// `squares-2x2` (outline, 24) — an "app" entry, in the blocker.
  static const String squares2x2 =
      'M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6a2.25 2.25 0 '
      '01-2.25-2.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18a2.25 2.25 0 '
      '01-2.25 2.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 '
      '0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25a2.25 2.25 0 01-2.25-2.25V6zM13.5 15.75a2.25 2.25 0 '
      '012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z';
}
