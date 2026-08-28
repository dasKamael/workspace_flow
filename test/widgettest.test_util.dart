import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:workspace_flow/common/translation/app_localizations.dart';
import 'package:workspace_flow/presentation/design_system/ui_theme.dart';

/// Pumps [child] inside the app's theme and localizations.
///
/// The window is sized to the design's 1240×736 body so cards get the room they were
/// laid out for; the default 800×600 test surface would overflow them.
Future<void> pumpAppWidget(
  WidgetTester tester, {
  required Widget child,
  ProviderContainer? container,
  Size surfaceSize = const Size(1240, 736),
  bool settle = true,
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final app = MaterialApp(
    theme: const UiTheme().lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  await tester.pumpWidget(
    container == null ? ProviderScope(child: app) : UncontrolledProviderScope(container: container, child: app),
  );

  if (settle) await tester.pumpAndSettle();
}

/// Pumps [child] on a route with no Scaffold above it.
///
/// The editors are transparent overlay routes, so anything that needs a `Material`
/// ancestor has to bring its own. This helper reproduces exactly that tree, which is
/// what a plain [pumpAppWidget] — with its Scaffold — would paper over.
Future<void> pumpOverlayRoute(
  WidgetTester tester, {
  required Widget child,
  ProviderContainer? container,
  Size surfaceSize = const Size(1240, 736),
  bool settle = true,
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
      GoRoute(
        path: '/overlay',
        pageBuilder: (context, state) => NoTransitionPage<void>(key: state.pageKey, child: child),
      ),
    ],
    initialLocation: '/overlay',
  );
  addTearDown(router.dispose);

  final app = MaterialApp.router(
    routerConfig: router,
    theme: const UiTheme().lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );

  await tester.pumpWidget(
    container == null ? ProviderScope(child: app) : UncontrolledProviderScope(container: container, child: app),
  );

  if (settle) await tester.pumpAndSettle();
}
