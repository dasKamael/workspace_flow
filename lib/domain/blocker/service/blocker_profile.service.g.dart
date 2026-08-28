// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocker_profile.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blockerProfilesHash() => r'b3a94730e22a338958e1b6bbd5a178fa1f77bd45';

/// All blocker profiles, kept in sync with the database.
///
/// Copied from [blockerProfiles].
@ProviderFor(blockerProfiles)
final blockerProfilesProvider = StreamProvider<List<BlockerProfile>>.internal(
  blockerProfiles,
  name: r'blockerProfilesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$blockerProfilesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BlockerProfilesRef = StreamProviderRef<List<BlockerProfile>>;
String _$selectedProfileHash() => r'a47db7f36f22a3ae6bcf3a8aa527d21214141f10';

/// The profile the blocker card is showing.
///
/// Derived for the same reason as [selectedProject]: watching the notifier does not
/// rebuild on a selection change.
///
/// Copied from [selectedProfile].
@ProviderFor(selectedProfile)
final selectedProfileProvider = Provider<BlockerProfile?>.internal(
  selectedProfile,
  name: r'selectedProfileProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$selectedProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedProfileRef = ProviderRef<BlockerProfile?>;
String _$selectedProfileServiceHash() => r'7ebbd510f31f56e0507fbb747da1e04ecaccf816';

/// Which profile the blocker card is showing.
///
/// Copied from [SelectedProfileService].
@ProviderFor(SelectedProfileService)
final selectedProfileServiceProvider = NotifierProvider<SelectedProfileService, int?>.internal(
  SelectedProfileService.new,
  name: r'selectedProfileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$selectedProfileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedProfileService = Notifier<int?>;
String _$blockerProfileServiceHash() => r'd00b74a3715c8817da00bb7a96114715cf6ce769';

/// Creating, saving and deleting profiles, and toggling single entries.
///
/// Copied from [BlockerProfileService].
@ProviderFor(BlockerProfileService)
final blockerProfileServiceProvider = NotifierProvider<BlockerProfileService, void>.internal(
  BlockerProfileService.new,
  name: r'blockerProfileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$blockerProfileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BlockerProfileService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
