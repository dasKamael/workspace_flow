import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workspace_flow/data/system/repository/layout_overlay.repository.dart';
import 'package:workspace_flow/domain/project/model/project_window.dart';
import 'package:workspace_flow/domain/project/service/layout_overlay.service.dart';
import 'package:workspace_flow/domain/project/service/project.service.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';
import 'package:workspace_flow/domain/system/model/screen_info.dart';
import 'package:workspace_flow/domain/system/service/screen.service.dart';

import '../../../mocks/system.mock.dart';
import '../../../riverpod.test_util.dart';

/// The editor just awaits a layout; the two-engine round trip stays behind the service.
void main() {
  late MockLayoutOverlayRepository overlay;

  const screens = [
    ScreenInfo(index: 0, visibleX: 0, visibleY: 25, visibleWidth: 2560, visibleHeight: 1415, isMain: true),
  ];

  const draft = [ProjectWindow(id: -1, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 50, height: 100)];
  const edited = [ProjectWindow(id: -1, name: 'VS Code', screenIndex: 0, x: 0, y: 0, width: 62.5, height: 100)];

  const library = [AppLibraryEntry(name: 'VS Code', bundleId: 'com.microsoft.VSCode')];

  setUpAll(() {
    registerFallbackValue(const <ProjectWindow>[]);
    registerFallbackValue(const <ScreenInfo>[]);
    registerFallbackValue(const <AppLibraryEntry>[]);
    registerFallbackValue(const <String, Uint8List>{});
  });

  setUp(() {
    overlay = MockLayoutOverlayRepository();
  });

  ProviderContainer makeContainer({List<ScreenInfo> attached = screens}) {
    final container = createContainer(
      overrides: [
        layoutOverlayRepositoryProvider.overrideWithValue(overlay),
        screensProvider.overrideWith((ref) async => attached),
        // The library travels into the overlay so apps can be dropped in from there.
        appLibraryProvider.overrideWith((ref) => Stream.value(library)),
      ],
    );
    // Riverpod 3 pauses a stream provider's subscription while nothing actively
    // listens to it — in the real app a widget's `ref.watch` does that; here nothing
    // otherwise would, so `LayoutOverlayService.edit`'s read of the library would hang.
    container.listen(appLibraryProvider, (_, _) {});
    return container;
  }

  Future<List<ProjectWindow>?> edit(ProviderContainer container) =>
      container.read(layoutOverlayServiceProvider.notifier).edit(draft);

  test('Given the overlay returns an edited layout, '
      'when the service is asked to edit, '
      'then it hands that layout back with the attached screens passed along', () async {
    // Given
    when(
      () => overlay.edit(
        windows: any(named: 'windows'),
        screens: any(named: 'screens'),
        library: any(named: 'library'),
        icons: any(named: 'icons'),
      ),
    ).thenAnswer((_) async => edited);

    // When
    final result = await edit(makeContainer());

    // Then
    expect(result, edited);
    verify(
      () => overlay.edit(
        windows: draft,
        screens: screens,
        library: library,
        icons: any(named: 'icons'),
      ),
    ).called(1);
  });

  test('Given the overlay was cancelled, '
      'when the service is asked to edit, '
      'then it returns null so the draft stays untouched', () async {
    // Given
    when(
      () => overlay.edit(
        windows: any(named: 'windows'),
        screens: any(named: 'screens'),
        library: any(named: 'library'),
        icons: any(named: 'icons'),
      ),
    ).thenAnswer((_) async => null);

    // When / Then
    expect(await edit(makeContainer()), isNull);
  });

  test('Given the bridge is unavailable, '
      'when the service is asked to edit, '
      'then it returns null instead of letting the failure reach the sheet', () async {
    // Given — the case outside macOS and in tests
    when(
      () => overlay.edit(
        windows: any(named: 'windows'),
        screens: any(named: 'screens'),
        library: any(named: 'library'),
        icons: any(named: 'icons'),
      ),
    ).thenThrow(Exception('unimplemented'));

    // When / Then
    expect(await edit(makeContainer()), isNull);
  });

  test('Given no screens are attached, '
      'when the service is asked to edit, '
      'then no overlay is opened at all', () async {
    // Given
    final container = makeContainer(attached: const []);

    // When / Then
    expect(await edit(container), isNull);
    verifyNever(
      () => overlay.edit(
        windows: any(named: 'windows'),
        screens: any(named: 'screens'),
        library: any(named: 'library'),
        icons: any(named: 'icons'),
      ),
    );
  });
}
