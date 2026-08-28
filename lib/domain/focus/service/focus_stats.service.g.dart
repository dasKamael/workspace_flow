// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_stats.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$focusStatsHash() => r'2744ff934cebeceeeecf70155c46a8da723cbdb8';

/// The two counters shown in the UI: sessions finished today and attempts blocked today.
///
/// Both are queried rather than counted in memory, so they survive a restart and roll
/// over at midnight on their own.
///
/// Copied from [focusStats].
@ProviderFor(focusStats)
final focusStatsProvider = StreamProvider<FocusStats>.internal(
  focusStats,
  name: r'focusStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$focusStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FocusStatsRef = StreamProviderRef<FocusStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
