// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$projectsHash() => r'07b8c428e4df234c4f654ad7408ffbc3431e8534';

/// All projects, kept in sync with the database.
///
/// Copied from [projects].
@ProviderFor(projects)
final projectsProvider = StreamProvider<List<Project>>.internal(
  projects,
  name: r'projectsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$projectsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectsRef = StreamProviderRef<List<Project>>;
String _$appLibraryHash() => r'2961f58d541ca7e379e592b98772c8dd96f22686';

/// The library of apps and websites offered as chips in the editor.
///
/// Copied from [appLibrary].
@ProviderFor(appLibrary)
final appLibraryProvider = StreamProvider<List<AppLibraryEntry>>.internal(
  appLibrary,
  name: r'appLibraryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$appLibraryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppLibraryRef = StreamProviderRef<List<AppLibraryEntry>>;
String _$selectedProjectHash() => r'39bc55339b8e02f6ec77005f98ad629358b43555';

/// The project the workspace is showing.
///
/// Derived rather than resolved at the call site: a widget that watched the notifier
/// instead of this would never rebuild when the selection changes.
/// Falls back to the first project when nothing is selected or the selection is gone.
///
/// Copied from [selectedProject].
@ProviderFor(selectedProject)
final selectedProjectProvider = Provider<Project?>.internal(
  selectedProject,
  name: r'selectedProjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$selectedProjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedProjectRef = ProviderRef<Project?>;
String _$selectedProjectServiceHash() => r'67bd09446aef102c61e50de3139f9c3a6130814b';

/// Which project is selected in the sidebar.
///
/// Selecting a project only changes the workspace view — it never touches the blocker
/// profile or the timer, which are independent features.
///
/// Copied from [SelectedProjectService].
@ProviderFor(SelectedProjectService)
final selectedProjectServiceProvider = NotifierProvider<SelectedProjectService, int?>.internal(
  SelectedProjectService.new,
  name: r'selectedProjectServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$selectedProjectServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedProjectService = Notifier<int?>;
String _$projectServiceHash() => r'82ed4d0680be0eb3d0035953d843c0fd14c9fee2';

/// Creating, saving and deleting projects.
///
/// Copied from [ProjectService].
@ProviderFor(ProjectService)
final projectServiceProvider = NotifierProvider<ProjectService, void>.internal(
  ProjectService.new,
  name: r'projectServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$projectServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProjectService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
