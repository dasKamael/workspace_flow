import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_motion.dart';
import 'package:workspace_flow/presentation/navigator_keys.dart';
import 'package:workspace_flow/presentation/screens/profile_editor/profile_editor.screen.dart';
import 'package:workspace_flow/presentation/screens/project_editor/project_editor.screen.dart';
import 'package:workspace_flow/presentation/screens/settings/settings.screen.dart';
import 'package:workspace_flow/presentation/screens/workspace/workspace.screen.dart';

part 'router.g.dart';

/// Every route in the app. Navigate with `context.goNamed(UiRoute.x.name)`.
enum UiRoute { workspace, projectEditor, profileEditor, settings }

/// Path parameters, so no route ever spells a key as a bare string.
enum RoutePathParam { id }

/// The running session and the blocked page are not routes: the session replaces the
/// workspace body in place (it is a state of the window, not a destination), and the
/// blocked page runs in its own window driven by a separate Flutter engine.
@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: UiRoute.workspace.name,
        builder: (context, state) => const WorkspaceScreen(),
        routes: [
          GoRoute(
            path: 'project/:${RoutePathParam.id.name}',
            name: UiRoute.projectEditor.name,
            pageBuilder: (context, state) => _sheetPage(state, ProjectEditorScreen(projectId: _idOf(state))),
          ),
          GoRoute(
            path: 'profile/:${RoutePathParam.id.name}',
            name: UiRoute.profileEditor.name,
            pageBuilder: (context, state) => _sheetPage(state, ProfileEditorScreen(profileId: _idOf(state))),
          ),
          GoRoute(
            path: 'settings',
            name: UiRoute.settings.name,
            pageBuilder: (context, state) => _sheetPage(state, const SettingsScreen()),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
}

/// The editors are sheets: they float over the workspace, which stays visible behind
/// the scrim, so they need a transparent page rather than an opaque one.
Page<void> _sheetPage(GoRouterState state, Widget child) => CustomTransitionPage<void>(
  key: state.pageKey,
  opaque: false,
  barrierDismissible: false,
  transitionDuration: UiMotion.sheet,
  reverseTransitionDuration: UiMotion.backdrop,
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
);

/// `new` is the sentinel for "create", matching the design's "New project" sheet.
int? _idOf(GoRouterState state) {
  final raw = state.pathParameters[RoutePathParam.id.name];
  return raw == null || raw == 'new' ? null : int.tryParse(raw);
}

/// The path segment used when creating rather than editing.
const String kNewEntitySegment = 'new';
