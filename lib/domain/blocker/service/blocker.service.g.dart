// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocker.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blockerServiceHash() => r'f2627b2580dcc754ac65143a54bb100501a6faaa';

/// Whether the blocker is armed, and what it is enforcing.
///
/// Arming is independent of projects and of the timer: a profile can run on its own.
///
/// Copied from [BlockerService].
@ProviderFor(BlockerService)
final blockerServiceProvider = NotifierProvider<BlockerService, bool>.internal(
  BlockerService.new,
  name: r'blockerServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$blockerServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BlockerService = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
