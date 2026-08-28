import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:workspace_flow/common/utils/platform_info.dart';
import 'package:workspace_flow/domain/system/service/seed.service.dart';
import 'package:workspace_flow/presentation/design_system/atoms/ui_size.dart';

/// Boots the app: window chrome, database, seed data, then the widget tree.
///
/// Each warm-up step is guarded on its own so a single failure — a display that cannot
/// be read, a seed that half ran — still leaves a usable window instead of a blank one.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      if (PlatformInfo.isDebugMode) FlutterError.presentError(details);
    };

    await _configureWindow();

    final container = ProviderContainer();
    await _warmUp(container);

    runApp(UncontrolledProviderScope(container: container, child: await builder()));
  }, (error, stack) => debugPrintStack(label: 'bootstrap: $error', stackTrace: stack));
}

/// Hidden title bar with the real traffic lights, sized to the design.
Future<void> _configureWindow() async {
  if (PlatformInfo.isTestMode) return;

  try {
    await windowManager.ensureInitialized();
    const size = Size(UiSize.windowWidth, UiSize.titleBarHeight + UiSize.windowBodyHeight);
    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        size: size,
        minimumSize: size,
        center: true,
        title: 'Focus',
        titleBarStyle: TitleBarStyle.hidden,
        backgroundColor: Color(0xFFF8FAFC),
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    );
  } on Object catch (error) {
    debugPrint('bootstrap: window setup failed — $error');
  }
}

Future<void> _warmUp(ProviderContainer container) async {
  try {
    await container.read(seedServiceProvider.notifier).seedIfEmpty();
  } on Object catch (error) {
    debugPrint('bootstrap: seeding failed — $error');
  }
}
