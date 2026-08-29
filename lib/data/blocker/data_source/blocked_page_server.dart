import 'dart:io';

import 'package:workspace_flow/data/blocker/data_source/blocked_page_html.dart';

/// The data a `/blocked` request renders, read live so the page always shows the
/// current profile and unlock count rather than whatever was true when it started.
typedef BlockedPageData = ({String profileName, int unlocksRemaining, int unlockMinutes});

/// A local, loopback-only web server that serves the "you're blocked" page a
/// redirected browser tab lands on.
///
/// Enforcement (`BlockerEnforcementService.swift`) never touches this directly — it
/// only needs the base URL to redirect a blocked tab to. Everything the page shows,
/// and what happens when "Unlock" is clicked, stays on the Dart side.
class BlockedPageServer {
  BlockedPageServer({required this.onUnlockRequested, required this.currentPageData});

  final Future<void> Function(String target) onUnlockRequested;
  final BlockedPageData Function() currentPageData;

  HttpServer? _server;

  /// The port bound to `127.0.0.1`, once [start] completes.
  int get port => _server?.port ?? 0;

  Future<void> start() async {
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _server!.listen(_handle);
  }

  Future<void> stop() async => _server?.close(force: true);

  Future<void> _handle(HttpRequest request) async {
    switch (request.uri.path) {
      case '/blocked':
        await _serveBlockedPage(request);
      case '/unlock':
        await _serveUnlock(request);
      default:
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
    }
  }

  Future<void> _serveBlockedPage(HttpRequest request) async {
    final target = request.uri.queryParameters['target'] ?? '';
    final returnUrl = request.uri.queryParameters['returnUrl'] ?? '';
    final data = currentPageData();

    final html = blockedPageHtml(
      target: target,
      profileName: data.profileName,
      unlocksRemaining: data.unlocksRemaining,
      unlockMinutes: data.unlockMinutes,
      returnUrl: returnUrl,
    );

    request.response.headers.contentType = ContentType.html;
    request.response.write(html);
    await request.response.close();
  }

  Future<void> _serveUnlock(HttpRequest request) async {
    final target = request.uri.queryParameters['target'] ?? '';
    final returnUrl = request.uri.queryParameters['returnUrl'];

    if (target.isNotEmpty) await onUnlockRequested(target);

    request.response.statusCode = HttpStatus.found;
    request.response.headers.set(HttpHeaders.locationHeader, (returnUrl?.isNotEmpty ?? false) ? returnUrl! : '/');
    await request.response.close();
  }
}
