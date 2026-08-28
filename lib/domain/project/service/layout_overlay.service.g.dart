// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_overlay.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$layoutOverlayServiceHash() => r'4c2c58cad12ba0f0ae37bdb87f93a985789dc8e2';

/// Lets a layout be arranged at full size on the real screens.
///
/// The miniature stage in the editor sheet is fine for a rough arrangement, but on a
/// 27″ display a tile there is a few hundred pixels wide — one cannot judge how large a
/// window will actually be. The overlay puts the same tiles on the real screens at
/// their real size.
///
/// Copied from [LayoutOverlayService].
@ProviderFor(LayoutOverlayService)
final layoutOverlayServiceProvider = NotifierProvider<LayoutOverlayService, void>.internal(
  LayoutOverlayService.new,
  name: r'layoutOverlayServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product') ? null : _$layoutOverlayServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LayoutOverlayService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
