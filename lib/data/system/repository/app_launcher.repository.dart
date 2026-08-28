import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/data/system/data_source/macos_bridge.channel.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

part 'app_launcher.repository.g.dart';

/// Launches applications and websites, and discovers what is installed.
class AppLauncherRepository {
  AppLauncherRepository({required this.channel});

  final MacosBridgeChannel channel;

  /// Applications found in `/Applications` and `~/Applications`.
  Future<List<AppLibraryEntry>> getInstalledApps() async {
    final rows = await channel.invokeList('getInstalledApps');
    return [
      for (final row in rows)
        AppLibraryEntry(
          name: row['name']?.toString() ?? '',
          bundleId: row['bundleId']?.toString(),
          path: row['path']?.toString(),
        ),
    ];
  }

  /// Opens the app with [bundleId] and returns its process id, which the window
  /// control side needs to address the right accessibility element.
  Future<int?> launchApp({required String bundleId}) => channel.invoke<int>('launchApp', {'bundleId': bundleId});

  /// Opens [url] in the default browser.
  Future<void> openUrl(String url) => channel.invoke<void>('openUrl', {'url': url});

  /// Shows an `NSOpenPanel` at [directory] and returns the chosen application,
  /// or `null` if the user cancelled.
  Future<AppLibraryEntry?> chooseApp({String directory = '/Applications'}) async {
    final row = await channel.invoke<Map<Object?, Object?>>('chooseApp', {'directory': directory});
    if (row == null) return null;
    return AppLibraryEntry(
      name: row['name']?.toString() ?? '',
      bundleId: row['bundleId']?.toString(),
      path: row['path']?.toString(),
    );
  }
}

@Riverpod(keepAlive: true)
AppLauncherRepository appLauncherRepository(Ref ref) =>
    AppLauncherRepository(channel: ref.watch(macosBridgeChannelProvider));
