import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';

part 'blocked_item.freezed.dart';

/// One entry of a blocker profile — an app or a domain.
///
/// [enabled] is the per-profile toggle from the design: clicking a row includes or
/// excludes that entry without removing it from the profile.
@freezed
abstract class BlockedItem with _$BlockedItem {
  const factory BlockedItem({
    required int id,
    required String name,
    required BlockedItemKind kind,
    @Default(true) bool enabled,
  }) = _BlockedItem;
}
