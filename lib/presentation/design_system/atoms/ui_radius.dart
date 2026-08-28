import 'package:flutter/painting.dart';

/// Corner radii of the design system.
class UiRadius {
  UiRadius._();

  /// 5 — tick boxes.
  static const Radius xs = Radius.circular(5);

  /// 7 — window tiles in the editor.
  static const Radius s = Radius.circular(7);

  /// 8 — buttons, inputs.
  static const Radius m = Radius.circular(8);

  /// 9 — blocker list rows.
  static const Radius ml = Radius.circular(9);

  /// 10 — monitor bezels, app rows.
  static const Radius l = Radius.circular(10);

  /// 12 — inner panels, project cards.
  static const Radius xl = Radius.circular(12);

  /// 14 — cards, sheets, the window itself.
  static const Radius xxl = Radius.circular(14);

  /// Pill — chips, switches, dots.
  static const Radius full = Radius.circular(9999);

  static const BorderRadius allXs = BorderRadius.all(xs);
  static const BorderRadius allS = BorderRadius.all(s);
  static const BorderRadius allM = BorderRadius.all(m);
  static const BorderRadius allMl = BorderRadius.all(ml);
  static const BorderRadius allL = BorderRadius.all(l);
  static const BorderRadius allXl = BorderRadius.all(xl);
  static const BorderRadius allXxl = BorderRadius.all(xxl);
  static const BorderRadius allFull = BorderRadius.all(full);
}
