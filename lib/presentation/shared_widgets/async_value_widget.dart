import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_color.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_typography.dart';

/// Renders an [AsyncValue] with quiet fallbacks.
///
/// The design has no spinners or error banners, so loading shows nothing and an error
/// shows a single muted line rather than intruding on the layout.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({required this.value, required this.data, this.loading, super.key});

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget? loading;

  @override
  Widget build(BuildContext context) => value.when(
    data: data,
    loading: () => loading ?? const SizedBox.shrink(),
    error: (error, _) => Text('$error', style: UiTypography.rowState.copyWith(color: UiColor.fgSubtle)),
  );
}
