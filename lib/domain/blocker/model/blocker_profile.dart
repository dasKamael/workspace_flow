import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';

part 'blocker_profile.freezed.dart';

/// A named bundle of blocked apps and websites.
///
/// Profiles are global: they are never bound to a project and can be armed on their own.
@freezed
abstract class BlockerProfile with _$BlockerProfile {
  const factory BlockerProfile({
    required int id,
    required String name,
    required List<BlockedItem> items,
    @Default(0) int sortOrder,
  }) = _BlockerProfile;

  const BlockerProfile._();

  /// The entries that are actually enforced while this profile is armed.
  List<BlockedItem> get enabledItems => items.where((item) => item.enabled).toList();
}
