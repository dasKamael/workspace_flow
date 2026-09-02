import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_preset.freezed.dart';

/// A preset length offered next to the dial.
///
/// [minutes] `0` means *open end*: the session counts up and has no end time. [id] is
/// the database row id — null only for the built-in Open End preset, which is never
/// persisted. [label] is the user's own text for a custom preset; Open End ignores it
/// in favour of the translated `focus_preset_open_end` string.
@freezed
abstract class FocusPreset with _$FocusPreset {
  const factory FocusPreset({
    int? id,
    required String label,
    required int minutes,
    @Default(false) bool isDefault,
  }) = _FocusPreset;

  const FocusPreset._();

  bool get isOpenEnd => minutes == 0;

  /// The fixed, non-deletable entry always offered last — see [isOpenEnd].
  static const FocusPreset openEnd = FocusPreset(label: '', minutes: 0);
}
