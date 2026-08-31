import 'package:workspace_flow/data/database/app_database.dart';
import 'package:workspace_flow/common/mapper/entity_mapper.dart';
import 'package:workspace_flow/domain/project/model/project.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

/// Maps a project row plus its window rows onto the domain [Project].
///
/// [toEntity] is not implemented: a project is written through
/// `ProjectRepository.saveProject`, which splits the aggregate across two tables.
class ProjectEntityMapper
    implements EntityMapper<Project, ({ProjectEntity project, List<ProjectWindowEntity> windows})> {
  const ProjectEntityMapper();

  static const ProjectWindowEntityMapper windowMapper = ProjectWindowEntityMapper();

  @override
  Project toModel(({ProjectEntity project, List<ProjectWindowEntity> windows}) entity) => Project(
    id: entity.project.id,
    name: entity.project.name,
    sortOrder: entity.project.sortOrder,
    windows: entity.windows.map(windowMapper.toModel).toList(),
  );

  @override
  ({ProjectEntity project, List<ProjectWindowEntity> windows}) toEntity(Project model) =>
      throw UnimplementedError('A project is persisted through ProjectRepository.saveProject');
}

class ProjectWindowEntityMapper implements EntityMapper<ProjectWindow, ProjectWindowEntity> {
  const ProjectWindowEntityMapper();

  @override
  ProjectWindow toModel(ProjectWindowEntity entity) => ProjectWindow(
    id: entity.id,
    name: entity.name,
    bundleId: entity.bundleId,
    url: entity.url,
    documentPath: entity.documentPath,
    screenIndex: entity.screenIndex,
    displayId: entity.displayId,
    x: entity.x,
    y: entity.y,
    width: entity.width,
    height: entity.height,
    sortOrder: entity.sortOrder,
  );

  @override
  ProjectWindowEntity toEntity(ProjectWindow model) =>
      throw UnimplementedError('Window rows are written as companions by ProjectRepository.saveProject');
}

class AppLibraryEntryMapper implements EntityMapper<AppLibraryEntry, AppLibraryEntity> {
  const AppLibraryEntryMapper();

  @override
  AppLibraryEntry toModel(AppLibraryEntity entity) => AppLibraryEntry(
    name: entity.name,
    bundleId: entity.bundleId,
    path: entity.path,
    url: entity.url,
    documentPath: entity.documentPath,
  );

  @override
  AppLibraryEntity toEntity(AppLibraryEntry model) =>
      throw UnimplementedError('Library rows are written as companions by ProjectRepository.addToAppLibrary');
}
