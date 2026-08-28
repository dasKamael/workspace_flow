// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seed.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$seedServiceHash() => r'df1aa81b0f8dea3126c90bf9994d651e72884dfc';

/// Fills an empty database on first start.
///
/// The content is the prototype's initial state, so a fresh install looks like the
/// design instead of an empty window. Runs only when there is nothing stored yet.
///
/// Copied from [SeedService].
@ProviderFor(SeedService)
final seedServiceProvider = NotifierProvider<SeedService, void>.internal(
  SeedService.new,
  name: r'seedServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$seedServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SeedService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
