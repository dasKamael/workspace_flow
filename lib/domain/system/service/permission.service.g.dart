// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accessibilityPermissionServiceHash() => r'574cdd25ba1519654c4ba5d76dd3dff61b3f0525';

/// Whether the app may move other apps' windows.
///
/// Without Accessibility permission a project can still launch its apps, but they land
/// wherever macOS puts them — the launch reports `needsAccessibilityPermission` so the
/// UI can offer the system settings.
///
/// Copied from [AccessibilityPermissionService].
@ProviderFor(AccessibilityPermissionService)
final accessibilityPermissionServiceProvider = AsyncNotifierProvider<AccessibilityPermissionService, bool>.internal(
  AccessibilityPermissionService.new,
  name: r'accessibilityPermissionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$accessibilityPermissionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccessibilityPermissionService = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
