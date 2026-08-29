import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace_flow/common/translation/app_localizations.dart';
import 'package:workspace_flow/presentation/design_system/ui_theme.dart';
import 'package:workspace_flow/presentation/screens/blocked_page/blocked_page.screen.dart';

/// The app rendered by the blocked-page engine.
///
/// It runs in its own isolate with no provider container: everything it shows arrives
/// over [_channel] from the native side, and its only actions go back the same way.
class BlockedPageApp extends StatefulWidget {
  const BlockedPageApp({super.key});

  @override
  State<BlockedPageApp> createState() => _BlockedPageAppState();
}

class _BlockedPageAppState extends State<BlockedPageApp> {
  static const MethodChannel _channel = MethodChannel('de.coodoo.workspace_flow/blocked_page');

  Map<String, Object?> _payload = const {};

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'update') return null;
      final arguments = call.arguments;
      if (arguments is Map) {
        setState(() => _payload = arguments.map((key, value) => MapEntry(key.toString(), value)));
      }
      return null;
    });
  }

  String? _string(String key) => _payload[key]?.toString();

  int _int(String key, int fallback) {
    final value = _payload[key];
    return value is num ? value.toInt() : fallback;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: const UiTheme().lightTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      backgroundColor: const Color(0x00000000),
      body: Center(
        child: BlockedPageScreen(
          target: _string('target') ?? '',
          profileName: _string('profileName') ?? '',
          projectName: _string('projectName'),
          endsAt: _string('endsAt'),
          remaining: _string('remaining'),
          unlockMinutes: _int('unlockMinutes', 2),
          unlocksLeft: _int('unlocksLeft', 0),
          onBackToWork: () => _channel.invokeMethod<void>('dismiss'),
          onUnlock: () => _channel.invokeMethod<void>('unlock', {'target': _string('target')}),
        ),
      ),
    ),
  );
}
