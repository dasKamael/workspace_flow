// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$launchServiceHash() => r'cd327ef8f784b068310c6f5e5836ea0126d22a2c';

/// Opens a project's apps and puts their windows back where they were saved.
///
/// Each window really is launched and positioned; the design's 520ms cascade is a
/// minimum dwell time on top of that, so a fast launch still reads as a sequence
/// instead of flashing every row to "open" at once.
///
/// Copied from [LaunchService].
@ProviderFor(LaunchService)
final launchServiceProvider = NotifierProvider<LaunchService, LaunchProgress>.internal(
  LaunchService.new,
  name: r'launchServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$launchServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LaunchService = Notifier<LaunchProgress>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
