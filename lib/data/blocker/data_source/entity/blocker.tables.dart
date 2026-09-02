import 'package:drift/drift.dart';

/// A named bundle of blocked apps and websites.
@DataClassName('BlockerProfileEntity')
class BlockerProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// One entry of a profile.
///
/// `enabled` is the per-profile toggle: an excluded entry stays in the profile but is
/// not enforced, which is what clicking a row in the blocker card does.
@DataClassName('BlockedItemEntity')
class BlockedItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(BlockerProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 300)();

  /// Serialised `BlockedItemKind`. Stored as text so the persistence format does
  /// not depend on the domain enum — the mapper owns the conversion.
  TextColumn get kind => text().withLength(min: 1, max: 20)();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Set for an app added through the Finder picker — lets enforcement match the
  /// running process reliably instead of by display name alone.
  TextColumn get bundleId => text().nullable()();
}

/// The single row of user-configurable "Unlock" allowance. `id` is always `1` — there
/// is exactly one set of these settings, not one per profile.
@DataClassName('BlockerSettingsEntity')
class BlockerSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get unlockMinutes => integer().withDefault(const Constant(2))();
  IntColumn get unlocksPerSession => integer().withDefault(const Constant(3))();

  @override
  Set<Column> get primaryKey => {id};
}
