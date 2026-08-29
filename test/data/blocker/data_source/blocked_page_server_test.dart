import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/data/blocker/data_source/blocked_page_server.dart';

/// The page a blocked tab is redirected to. Real loopback HTTP requests against a real
/// bound server — the whole point of this class is what a browser actually receives.
void main() {
  late BlockedPageServer server;
  late List<String> unlockRequests;

  setUp(() async {
    unlockRequests = [];
    server = BlockedPageServer(
      onUnlockRequested: (target) async => unlockRequests.add(target),
      currentPageData: () => (profileName: 'Deep Work', unlocksRemaining: 2, unlockMinutes: 2),
    );
    await server.start();
  });

  tearDown(() => server.stop());

  Future<HttpClientResponse> get(String path, {bool followRedirects = true}) async {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('http://127.0.0.1:${server.port}$path'));
    request.followRedirects = followRedirects;
    final response = await request.close();
    client.close();
    return response;
  }

  test('Given a blocked domain, '
      'when its page is requested, '
      'then it names the domain and the armed profile', () async {
    // When
    final response = await get('/blocked?target=youtube.com&returnUrl=https%3A%2F%2Fyoutube.com%2F');
    final body = await response.transform(utf8.decoder).join();

    // Then
    expect(response.statusCode, 200);
    expect(body, contains('youtube.com'));
    expect(body, contains('Deep Work'));
    expect(body, contains('Unlock 2 min · 2 left'));
  });

  test('Given no unlocks remaining, '
      'when the page is requested, '
      'then the unlock link is replaced with a plain notice', () async {
    // Given
    await server.stop();
    server = BlockedPageServer(
      onUnlockRequested: (target) async {},
      currentPageData: () => (profileName: 'Deep Work', unlocksRemaining: 0, unlockMinutes: 2),
    );
    await server.start();

    // When
    final response = await get('/blocked?target=youtube.com&returnUrl=https%3A%2F%2Fyoutube.com%2F');
    final body = await response.transform(utf8.decoder).join();

    // Then
    expect(body, contains('No unlocks left'));
    expect(body, isNot(contains('href="/unlock')));
  });

  test('Given the unlock link, '
      'when it is requested, '
      'then it reports the target and redirects back to the original page', () async {
    // When
    final response = await get(
      '/unlock?target=youtube.com&returnUrl=https%3A%2F%2Fyoutube.com%2F',
      followRedirects: false,
    );

    // Then
    expect(unlockRequests, ['youtube.com']);
    expect(response.statusCode, HttpStatus.found);
    expect(response.headers.value(HttpHeaders.locationHeader), 'https://youtube.com/');
  });

  test('Given an unknown path, '
      'when it is requested, '
      'then it 404s rather than leaking a directory listing or similar', () async {
    // When
    final response = await get('/something-else');

    // Then
    expect(response.statusCode, HttpStatus.notFound);
  });
}
