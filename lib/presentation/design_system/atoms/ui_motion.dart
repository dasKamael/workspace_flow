import 'package:flutter/animation.dart';

/// Motion tokens. One easing curve everywhere: `cubic-bezier(0.4, 0, 0.2, 1)`.
class UiMotion {
  UiMotion._();

  /// `cubic-bezier(0.4, 0, 0.2, 1)`
  static const Curve ease = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Buttons, links, colour swaps — 200ms.
  static const Duration fast = Duration(milliseconds: 200);

  /// Dial arc and tick transitions — 180ms / 220ms.
  static const Duration dialArc = Duration(milliseconds: 180);
  static const Duration dialTick = Duration(milliseconds: 220);

  /// Cards, rows — 300ms.
  static const Duration base = Duration(milliseconds: 300);

  /// State transitions (blocker idle ↔ active), card entrance — 320ms.
  static const Duration slow = Duration(milliseconds: 320);

  /// Sheet entrance — 260ms, backdrop 200ms.
  static const Duration sheet = Duration(milliseconds: 260);
  static const Duration backdrop = Duration(milliseconds: 200);

  /// Tick mark entrance — 260ms.
  static const Duration tickIn = Duration(milliseconds: 260);

  /// Row entrance — 300ms with a 40ms stagger.
  static const Duration rowIn = Duration(milliseconds: 300);
  static const Duration rowStagger = Duration(milliseconds: 40);

  /// Project card entrance — 320ms with a 60ms stagger.
  static const Duration cardIn = Duration(milliseconds: 320);
  static const Duration cardStagger = Duration(milliseconds: 60);

  /// Blocker row flash on activation — 380ms with a 45ms stagger.
  static const Duration lockIn = Duration(milliseconds: 380);
  static const Duration lockInStagger = Duration(milliseconds: 45);

  /// Progress bar of an opening app row — 520ms linear.
  static const Duration barGrow = Duration(milliseconds: 520);

  /// Centre number pop on a dial snap — 220ms.
  static const Duration numPop = Duration(milliseconds: 220);

  /// Entrance of the running-session view — 420ms.
  static const Duration focusIn = Duration(milliseconds: 420);

  /// Burst when a session starts — 620ms.
  static const Duration startBurst = Duration(milliseconds: 620);

  /// Padlock overlay when the blocker is armed — 900ms.
  static const Duration lockPop = Duration(milliseconds: 900);

  /// Activation sweep bar — 620ms.
  static const Duration sweep = Duration(milliseconds: 620);

  /// Ring pulse on the "Open" button of the picker — 620ms.
  static const Duration buttonPulse = Duration(milliseconds: 620);

  /// Pulsing "in focus" dot — 2.6s, repeating.
  static const Duration pulseDot = Duration(milliseconds: 2600);

  /// One tick of the running countdown.
  static const Duration tick = Duration(seconds: 1);

  /// Button hover lift.
  static const double liftButton = -1.0;

  /// Card hover lift.
  static const double liftCard = -4.0;

  /// Project card hover lift.
  static const double liftProjectCard = -2.0;
}
