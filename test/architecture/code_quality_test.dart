import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

/// Rules that keep the codebase readable and testable.
void main() {
  test('Given every file in lib, '
      'when its imports are inspected, '
      'then they are package imports rather than relative ones', () {
    expectNoMatchInLib(
      pattern: RegExp(r"""^\s*import\s+['"](?!package:|dart:)""", multiLine: true),
      reason: 'Use package: imports in lib/ so a file can be moved without rewriting its imports.',
    );
  });

  test('Given every file in lib, '
      'when it is inspected for logging, '
      'then it does not print to the console', () {
    expectNoMatchInLib(
      pattern: RegExp(r'(?<![\w.])(print|debugPrint)\('),
      reason: 'Console output does not survive a release build; report the failure instead.',
      knownViolations: [
        // Boot diagnostics run before any UI exists, so there is nowhere else to
        // report a failed window, database or seed step.
        'lib/bootstrap.dart',
      ],
    );
  });

  test('Given every file in lib, '
      'when platform checks are inspected, '
      'then they go through PlatformInfo', () {
    expectNoMatchInLib(
      pattern: RegExp(r'(?<![\w.])(kDebugMode|kReleaseMode|Platform\.(is|environment|operatingSystem))'),
      reason: 'Use PlatformInfo so tests can reason about the environment.',
      knownViolations: ['lib/common/utils/platform_info.dart'],
    );
  });

  test('Given the lib directory, '
      'when it is scanned, '
      'then it contains no test files', () {
    final testFiles = sourceFilesIn('lib').where((file) => file.fileName.endsWith('_test.dart')).toList();
    expect(testFiles, isEmpty, reason: 'Tests belong in test/, not in lib/.');
  });
}
