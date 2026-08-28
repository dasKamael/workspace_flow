import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/blocker/repository/blocker_profile.repository.dart';
import 'package:workspace_flow/data/project/repository/project.repository.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item.dart';
import 'package:workspace_flow/domain/blocker/model/blocked_item_kind.enum.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

part 'seed.service.g.dart';

/// Fills an empty database on first start.
///
/// The content is the prototype's initial state, so a fresh install looks like the
/// design instead of an empty window. Runs only when there is nothing stored yet.
@Riverpod(keepAlive: true)
class SeedService extends _$SeedService {
  @override
  void build() {}

  Future<void> seedIfEmpty() async {
    await _seedProjects();
    await _seedProfiles();
  }

  Future<void> _seedProjects() async {
    final repository = ref.read(projectRepositoryProvider);
    if (await repository.countProjects() > 0) return;

    for (final entry in _library) {
      await repository.addToAppLibrary(entry);
    }

    await repository.createProject(
      name: 'App-Care Sprint',
      windows: [
        _window('VS Code', screen: 0, x: 0, width: 62.5),
        _window('Figma', screen: 0, x: 62.5, width: 37.5),
        _window('Chrome', screen: 1, width: 100, height: 60),
        _window('Terminal', screen: 1, y: 60, width: 100, height: 40),
      ],
    );
    await repository.createProject(
      name: 'Deep Writing',
      windows: [
        _window('Ulysses', screen: 0, x: 12.5, width: 75),
        _window('Chrome', screen: 1, width: 100, height: 70),
        _window('Spotify', screen: 1, y: 70, width: 100, height: 30),
      ],
    );
    await repository.createProject(
      name: 'Admin & Inbox',
      windows: [
        _window('Mail', screen: 0, width: 50),
        _window('Calendar', screen: 0, x: 50, width: 50),
        _window('Numbers', screen: 1, width: 100),
      ],
    );
  }

  Future<void> _seedProfiles() async {
    final repository = ref.read(blockerProfileRepositoryProvider);
    if (await repository.countProfiles() > 0) return;

    await repository.createProfile(
      name: 'Deep Work',
      items: _items(['x.com', 'youtube.com', 'reddit.com', 'news.ycombinator.com', 'Slack', 'Mail', 'Messages']),
    );
    await repository.createProfile(name: 'Code', items: _items(['x.com', 'youtube.com', 'Slack', 'Mail']));
    await repository.createProfile(name: 'Admin light', items: _items(['youtube.com', 'Messages']));
  }

  static List<BlockedItem> _items(List<String> names) => [
    for (final name in names) BlockedItem(id: 0, name: name, kind: BlockedItemKind.fromInput(name)),
  ];

  static ProjectWindow _window(
    String name, {
    required int screen,
    double x = 0,
    double y = 0,
    double width = 50,
    double height = 100,
  }) => ProjectWindow(id: 0, name: name, screenIndex: screen, x: x, y: y, width: width, height: height);

  static const List<AppLibraryEntry> _library = [
    AppLibraryEntry(name: 'VS Code'),
    AppLibraryEntry(name: 'Figma'),
    AppLibraryEntry(name: 'Chrome'),
    AppLibraryEntry(name: 'Terminal'),
    AppLibraryEntry(name: 'Slack'),
    AppLibraryEntry(name: 'Mail'),
    AppLibraryEntry(name: 'Calendar'),
    AppLibraryEntry(name: 'Notion'),
    AppLibraryEntry(name: 'Ulysses'),
    AppLibraryEntry(name: 'Spotify'),
    AppLibraryEntry(name: 'Numbers'),
    AppLibraryEntry(name: 'Messages'),
  ];
}
