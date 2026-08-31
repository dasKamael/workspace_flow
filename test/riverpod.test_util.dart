import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

/// Creates a [ProviderContainer] that is disposed at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(parent: parent, overrides: overrides, observers: observers);
  addTearDown(container.dispose);
  return container;
}

/// Waits until [read] satisfies [predicate], polling the real event loop.
///
/// Needed for stream-backed providers: `provider.future` completes with the *first*
/// value only, so a later emission — a row written after the first read — is invisible
/// to it. sqlite runs on a background isolate, so the wait has to be real time.
Future<T> waitForProvider<T>(
  T Function() read,
  bool Function(T value) predicate, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    final value = read();
    if (predicate(value)) return value;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  throw StateError('Provider never satisfied the expected condition within $timeout');
}
