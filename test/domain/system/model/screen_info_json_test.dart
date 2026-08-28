import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';

/// Both models cross a method channel to reach the layout overlay, which runs in its
/// own Flutter engine. A lossy round trip there would move windows.
void main() {
  test('Given a screen with a known diagonal, '
      'when it round-trips through JSON, '
      'then every field survives', () {
    // Given
    const screen = ScreenInfo(
      index: 1,
      visibleX: 2560,
      visibleY: 25,
      visibleWidth: 1512,
      visibleHeight: 945,
      isMain: false,
      diagonalInches: 14.2,
    );

    // When
    final restored = ScreenInfo.fromJson(screen.toJson());

    // Then
    expect(restored, screen);
  });

  test('Given a screen whose diagonal the system did not report, '
      'when it round-trips, '
      'then the missing value stays missing', () {
    // Given
    const screen = ScreenInfo(
      index: 0,
      visibleX: 0,
      visibleY: 0,
      visibleWidth: 1920,
      visibleHeight: 1200,
      isMain: true,
    );

    // When / Then
    expect(ScreenInfo.fromJson(screen.toJson()).diagonalInches, isNull);
  });

  test('Given a window with fractional percentages, '
      'when it round-trips through JSON, '
      'then the geometry is unchanged', () {
    // Given — the 62.5/37.5 split from the design
    const window = ProjectWindow(
      id: -1,
      name: 'VS Code',
      bundleId: 'com.microsoft.VSCode',
      screenIndex: 0,
      x: 0,
      y: 0,
      width: 62.5,
      height: 100,
      sortOrder: 3,
    );

    // When
    final restored = ProjectWindow.fromJson(window.toJson());

    // Then
    expect(restored, window);
  });

  test('Given a website entry, '
      'when it round-trips, '
      'then the url survives and the bundle id stays null', () {
    // Given
    const window = ProjectWindow(
      id: -2,
      name: 'app-care.de',
      url: 'https://app-care.de',
      screenIndex: 1,
      x: 10,
      y: 20,
      width: 30,
      height: 40,
    );

    // When
    final restored = ProjectWindow.fromJson(window.toJson());

    // Then
    expect(restored.url, 'https://app-care.de');
    expect(restored.bundleId, isNull);
    expect(restored.isWebsite, isTrue);
  });
}
