import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/system/repository/app_launcher.repository.dart';
import 'package:workspace_flow/data/system/repository/blocked_window.repository.dart';
import 'package:workspace_flow/data/system/repository/layout_overlay.repository.dart';
import 'package:workspace_flow/data/system/repository/menu_bar.repository.dart';
import 'package:workspace_flow/data/system/repository/window_control.repository.dart';

class MockAppLauncherRepository extends Mock implements AppLauncherRepository {}

class MockWindowControlRepository extends Mock implements WindowControlRepository {}

class MockLayoutOverlayRepository extends Mock implements LayoutOverlayRepository {}

class MockBlockedWindowRepository extends Mock implements BlockedWindowRepository {}

class MockMenuBarRepository extends Mock implements MenuBarRepository {}
