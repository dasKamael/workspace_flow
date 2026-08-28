import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';

part 'project.freezed.dart';

/// A saved window layout.
///
/// A project stores nothing but its layout — it never references a blocker profile or
/// the timer, which are independent features.
@freezed
abstract class Project with _$Project {
  const factory Project({
    required int id,
    required String name,
    required List<ProjectWindow> windows,
    @Default(0) int sortOrder,
  }) = _Project;

  const Project._();

  int get windowCount => windows.length;

  /// Screen indices this project places windows on.
  Set<int> get usedScreenIndices => windows.map((window) => window.screenIndex).toSet();
}
