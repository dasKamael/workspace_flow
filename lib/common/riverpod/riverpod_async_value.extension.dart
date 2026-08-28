import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RiverpodAsyncValueExtension on AsyncValue<Object?> {
  /// `isLoading` shorthand ([AsyncLoading] is a subclass of [AsyncValue]).
  bool get isLoading => this is AsyncLoading;
}
