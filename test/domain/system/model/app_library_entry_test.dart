import 'package:flutter_test/flutter_test.dart';
import 'package:workspace_flow/domain/system/model/app_library_entry.dart';

/// A developer typically has one editor but several projects — "VS Code" opening
/// client-a and "VS Code" opening client-b must be able to coexist as distinct chips
/// even though they share a bundle id.
void main() {
  test('Given two entries for the same app with different project folders, '
      'when their keys are read, '
      'then they are distinct', () {
    // Given
    const clientA = AppLibraryEntry(
      name: 'VS Code — client-a',
      bundleId: 'com.microsoft.VSCode',
      documentPath: '/Users/dev/client-a',
    );
    const clientB = AppLibraryEntry(
      name: 'VS Code — client-b',
      bundleId: 'com.microsoft.VSCode',
      documentPath: '/Users/dev/client-b',
    );

    // When / Then
    expect(clientA.key, isNot(clientB.key));
  });

  test('Given a plain app entry and a project variant of the same app, '
      'when their keys are read, '
      'then they are distinct too', () {
    // Given
    const plain = AppLibraryEntry(name: 'VS Code', bundleId: 'com.microsoft.VSCode');
    const project = AppLibraryEntry(
      name: 'VS Code — client-a',
      bundleId: 'com.microsoft.VSCode',
      documentPath: '/Users/dev/client-a',
    );

    // When / Then
    expect(plain.key, isNot(project.key));
  });

  test('Given an entry with no bundle id, path or url, '
      'when its key is read, '
      'then it falls back to the name', () {
    // Given / When / Then
    expect(const AppLibraryEntry(name: 'Untitled').key, 'Untitled');
  });

  test('Given a website entry, '
      'when its key is read, '
      'then the url wins even if a bundle id happened to be set', () {
    // Given / When / Then
    expect(const AppLibraryEntry(name: 'App-Care', url: 'https://app-care.de').key, 'https://app-care.de');
  });
}
