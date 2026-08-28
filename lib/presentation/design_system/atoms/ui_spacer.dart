import 'package:flutter/widgets.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';

/// Ready-made gaps, used directly as children of a [Row] or [Column].
class UiSpacer {
  UiSpacer._();

  /// 4.0
  static const Widget xxs = SizedBox(width: UiSize.xxs, height: UiSize.xxs);

  /// 6.0
  static const Widget xs = SizedBox(width: UiSize.xs, height: UiSize.xs);

  /// 8.0
  static const Widget s = SizedBox(width: UiSize.s, height: UiSize.s);

  /// 10.0
  static const Widget sm = SizedBox(width: UiSize.sm, height: UiSize.sm);

  /// 12.0
  static const Widget m = SizedBox(width: UiSize.m, height: UiSize.m);

  /// 14.0
  static const Widget ml = SizedBox(width: UiSize.ml, height: UiSize.ml);

  /// 16.0
  static const Widget l = SizedBox(width: UiSize.l, height: UiSize.l);

  /// 20.0
  static const Widget xl = SizedBox(width: UiSize.xl, height: UiSize.xl);

  /// 26.0
  static const Widget xxl = SizedBox(width: UiSize.xxl, height: UiSize.xxl);

  /// 32.0
  static const Widget xxxl = SizedBox(width: UiSize.xxxl, height: UiSize.xxxl);
}
