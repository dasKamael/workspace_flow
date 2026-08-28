import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_preset.freezed.dart';

/// A preset length offered next to the dial.
///
/// [minutes] `0` means *open end*: the session counts up and has no end time.
@freezed
abstract class FocusPreset with _$FocusPreset {
  const factory FocusPreset({required String id, required int minutes}) = _FocusPreset;

  const FocusPreset._();

  bool get isOpenEnd => minutes == 0;

  /// The four presets from the design, in order.
  static const List<FocusPreset> all = [pomodoro, deepWork, longHaul, openEnd];

  static const FocusPreset pomodoro = FocusPreset(id: 'pomodoro', minutes: 25);
  static const FocusPreset deepWork = FocusPreset(id: 'deep_work', minutes: 50);
  static const FocusPreset longHaul = FocusPreset(id: 'long_haul', minutes: 90);
  static const FocusPreset openEnd = FocusPreset(id: 'open_end', minutes: 0);
}
