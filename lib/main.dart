import 'package:flutter/widgets.dart';
import 'package:workspace_flow/bootstrap.dart';
import 'package:workspace_flow/presentation/app.dart';
import 'package:workspace_flow/presentation/screens/blocked_page/blocked_page.app.dart';
import 'package:workspace_flow/presentation/screens/layout_overlay/layout_overlay.app.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}

/// Entry point of the second Flutter engine that renders the blocked page in its own
/// borderless window. Started from Swift by name, so it must survive tree shaking.
@pragma('vm:entry-point')
void blockedPage() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BlockedPageApp());
}

/// Entry point of the engine that renders the layout overlay across every screen.
/// Started from Swift by name, so it must survive tree shaking.
@pragma('vm:entry-point')
void layoutOverlay() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LayoutOverlayApp());
}
