// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_editor.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileEditorControllerHash() => r'98dccf161a89a6058379b7cabc861afcdf2bde71';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProfileEditorController extends BuildlessAutoDisposeNotifier<ProfileEditorState> {
  late final int? profileId;

  ProfileEditorState build(int? profileId);
}

/// Drives the blocker profile editor sheet.
///
/// Copied from [ProfileEditorController].
@ProviderFor(ProfileEditorController)
const profileEditorControllerProvider = ProfileEditorControllerFamily();

/// Drives the blocker profile editor sheet.
///
/// Copied from [ProfileEditorController].
class ProfileEditorControllerFamily extends Family<ProfileEditorState> {
  /// Drives the blocker profile editor sheet.
  ///
  /// Copied from [ProfileEditorController].
  const ProfileEditorControllerFamily();

  /// Drives the blocker profile editor sheet.
  ///
  /// Copied from [ProfileEditorController].
  ProfileEditorControllerProvider call(int? profileId) {
    return ProfileEditorControllerProvider(profileId);
  }

  @override
  ProfileEditorControllerProvider getProviderOverride(covariant ProfileEditorControllerProvider provider) {
    return call(provider.profileId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'profileEditorControllerProvider';
}

/// Drives the blocker profile editor sheet.
///
/// Copied from [ProfileEditorController].
class ProfileEditorControllerProvider
    extends AutoDisposeNotifierProviderImpl<ProfileEditorController, ProfileEditorState> {
  /// Drives the blocker profile editor sheet.
  ///
  /// Copied from [ProfileEditorController].
  ProfileEditorControllerProvider(int? profileId)
    : this._internal(
        () => ProfileEditorController()..profileId = profileId,
        from: profileEditorControllerProvider,
        name: r'profileEditorControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$profileEditorControllerHash,
        dependencies: ProfileEditorControllerFamily._dependencies,
        allTransitiveDependencies: ProfileEditorControllerFamily._allTransitiveDependencies,
        profileId: profileId,
      );

  ProfileEditorControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final int? profileId;

  @override
  ProfileEditorState runNotifierBuild(covariant ProfileEditorController notifier) {
    return notifier.build(profileId);
  }

  @override
  Override overrideWith(ProfileEditorController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileEditorControllerProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProfileEditorController, ProfileEditorState> createElement() {
    return _ProfileEditorControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileEditorControllerProvider && other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProfileEditorControllerRef on AutoDisposeNotifierProviderRef<ProfileEditorState> {
  /// The parameter `profileId` of this provider.
  int? get profileId;
}

class _ProfileEditorControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProfileEditorController, ProfileEditorState>
    with ProfileEditorControllerRef {
  _ProfileEditorControllerProviderElement(super.provider);

  @override
  int? get profileId => (origin as ProfileEditorControllerProvider).profileId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
