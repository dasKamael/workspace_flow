import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_library_entry.freezed.dart';
part 'app_library_entry.g.dart';

/// An app or website available as a chip in the project editor.
///
/// Apps are discovered from `/Applications` and `~/Applications` or added through the
/// Finder picker; websites are typed into the editor's URL field.
@freezed
abstract class AppLibraryEntry with _$AppLibraryEntry {
  const factory AppLibraryEntry({required String name, String? bundleId, String? path, String? url}) = _AppLibraryEntry;

  /// Read back in the layout overlay, which runs in its own Flutter engine.
  factory AppLibraryEntry.fromJson(Map<String, dynamic> json) => _$AppLibraryEntryFromJson(json);

  const AppLibraryEntry._();

  bool get isWebsite => url != null;

  /// Identity used to tell whether this entry is already placed in the current layout.
  String get key => url ?? bundleId ?? name;
}
