// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$focusSessionServiceHash() => r'cb72a011b91ee1366277e90a5034c9fe2b3907e8';

/// Owns the focus timer: length, countdown, and the session records it writes.
///
/// The tick is driven by a one-second [Timer], but the numbers are derived from
/// [clock] rather than counted up — a timer that fires late or is throttled while the
/// window is hidden must not make the session run long.
///
/// Copied from [FocusSessionService].
@ProviderFor(FocusSessionService)
final focusSessionServiceProvider = NotifierProvider<FocusSessionService, FocusSession>.internal(
  FocusSessionService.new,
  name: r'focusSessionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$focusSessionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FocusSessionService = Notifier<FocusSession>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
