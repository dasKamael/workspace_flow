// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_editor.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectEditorControllerHash() => r'b7671dc20f5d475c82066fcbe2fbbe7cd4e14b0f';

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

abstract class _$ProjectEditorController extends BuildlessAutoDisposeNotifier<ProjectEditorState> {
  late final int? projectId;

  ProjectEditorState build(int? projectId);
}

/// Drives the project editor sheet.
///
/// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
///
/// Copied from [ProjectEditorController].
@ProviderFor(ProjectEditorController)
const projectEditorControllerProvider = ProjectEditorControllerFamily();

/// Drives the project editor sheet.
///
/// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
///
/// Copied from [ProjectEditorController].
class ProjectEditorControllerFamily extends Family<ProjectEditorState> {
  /// Drives the project editor sheet.
  ///
  /// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
  ///
  /// Copied from [ProjectEditorController].
  const ProjectEditorControllerFamily();

  /// Drives the project editor sheet.
  ///
  /// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
  ///
  /// Copied from [ProjectEditorController].
  ProjectEditorControllerProvider call(int? projectId) {
    return ProjectEditorControllerProvider(projectId);
  }

  @override
  ProjectEditorControllerProvider getProviderOverride(covariant ProjectEditorControllerProvider provider) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies => _allTransitiveDependencies;

  @override
  String? get name => r'projectEditorControllerProvider';
}

/// Drives the project editor sheet.
///
/// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
///
/// Copied from [ProjectEditorController].
class ProjectEditorControllerProvider
    extends AutoDisposeNotifierProviderImpl<ProjectEditorController, ProjectEditorState> {
  /// Drives the project editor sheet.
  ///
  /// Everything happens on a draft; Save writes it back in one go, Cancel throws it away.
  ///
  /// Copied from [ProjectEditorController].
  ProjectEditorControllerProvider(int? projectId)
    : this._internal(
        () => ProjectEditorController()..projectId = projectId,
        from: projectEditorControllerProvider,
        name: r'projectEditorControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$projectEditorControllerHash,
        dependencies: ProjectEditorControllerFamily._dependencies,
        allTransitiveDependencies: ProjectEditorControllerFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  ProjectEditorControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final int? projectId;

  @override
  ProjectEditorState runNotifierBuild(covariant ProjectEditorController notifier) {
    return notifier.build(projectId);
  }

  @override
  Override overrideWith(ProjectEditorController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProjectEditorControllerProvider._internal(
        () => create()..projectId = projectId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProjectEditorController, ProjectEditorState> createElement() {
    return _ProjectEditorControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProjectEditorControllerProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProjectEditorControllerRef on AutoDisposeNotifierProviderRef<ProjectEditorState> {
  /// The parameter `projectId` of this provider.
  int? get projectId;
}

class _ProjectEditorControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProjectEditorController, ProjectEditorState>
    with ProjectEditorControllerRef {
  _ProjectEditorControllerProviderElement(super.provider);

  @override
  int? get projectId => (origin as ProjectEditorControllerProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
