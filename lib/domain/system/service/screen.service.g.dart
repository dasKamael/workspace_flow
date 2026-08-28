// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$screensHash() => r'eee9dc5a466d238a73b45799bde95e5f3f8baffc';

/// The attached displays.
///
/// Falls back to a single 16:10 stage when the native side is unavailable (tests, other
/// platforms) so the editor always has something to draw.
///
/// Copied from [screens].
@ProviderFor(screens)
final screensProvider = FutureProvider<List<ScreenInfo>>.internal(
  screens,
  name: r'screensProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$screensHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScreensRef = FutureProviderRef<List<ScreenInfo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
