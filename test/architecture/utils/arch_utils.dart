import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// One Dart source file, with its imports already extracted.
class SourceFile {
  SourceFile({required this.path, required this.content});

  /// Path relative to the package root, e.g. `lib/domain/focus/model/focus_session.dart`.
  final String path;
  final String content;

  late final List<String> imports = RegExp(
    r"""^\s*import\s+['"]([^'"]+)['"]""",
    multiLine: true,
  ).allMatches(content).map((match) => match.group(1)!).toList();

  String get fileName => path.split('/').last;
}

/// Every non-generated Dart file under [directory].
///
/// Generated output is excluded: the rules describe code people write, and the
/// generators do not follow them. That covers `*.g.dart` and `*.freezed.dart` from
/// build_runner, plus the `gen-l10n` output, which carries no marker of its own and
/// happens to use relative imports.
List<SourceFile> sourceFilesIn(String directory) {
  final root = Directory(directory);
  if (!root.existsSync()) return [];

  return root
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .where((file) => !_isGenerated(file.path))
      .map(
        (file) => SourceFile(
          path: file.path.replaceFirst('${Directory.current.path}/', ''),
          content: file.readAsStringSync(),
        ),
      )
      .toList();
}

bool _isGenerated(String path) =>
    path.endsWith('.g.dart') || path.endsWith('.freezed.dart') || path.contains('/translation/app_localizations');

/// Fails when any file in [fromLayer] imports [toLayer].
///
/// [knownViolations] documents accepted exceptions — each entry is a relative path and
/// should carry a comment explaining why it is allowed to stay.
void expectNoImport({required String fromLayer, required String toLayer, List<String> knownViolations = const []}) {
  final needle = 'package:workspace_flow/$toLayer/';
  final violations = <String>[];

  for (final file in sourceFilesIn('lib/$fromLayer')) {
    if (knownViolations.contains(file.path)) continue;
    for (final import in file.imports) {
      if (import.startsWith(needle)) violations.add('${file.path} -> $import');
    }
  }

  expect(violations, isEmpty, reason: 'Layer "$fromLayer" must not depend on "$toLayer".\n${violations.join('\n')}');
}

/// Fails when a file named `*.<suffix>.dart` contains no declaration matching [pattern].
void expectDeclarationForSuffix({
  required String suffix,
  required RegExp pattern,
  required String description,
  List<String> knownViolations = const [],
}) {
  final violations = <String>[];

  for (final file in sourceFilesIn('lib')) {
    if (!file.fileName.endsWith('.$suffix.dart')) continue;
    if (knownViolations.contains(file.path)) continue;
    if (!pattern.hasMatch(file.content)) violations.add(file.path);
  }

  expect(violations, isEmpty, reason: 'Files named *.$suffix.dart must $description.\n${violations.join('\n')}');
}

/// Fails when a file named `*.<suffix>.dart` lives outside [allowedDirectory].
void expectSuffixOnlyIn({required String suffix, required String allowedDirectory}) {
  final violations = sourceFilesIn('lib')
      .where((file) => file.fileName.endsWith('.$suffix.dart'))
      .where((file) => !file.path.startsWith('lib/$allowedDirectory/'))
      .map((file) => file.path)
      .toList();

  expect(violations, isEmpty, reason: '*.$suffix.dart belongs in lib/$allowedDirectory/.\n${violations.join('\n')}');
}

/// Fails when any file in `lib/` matches [pattern].
void expectNoMatchInLib({required RegExp pattern, required String reason, List<String> knownViolations = const []}) {
  final violations = <String>[];

  for (final file in sourceFilesIn('lib')) {
    if (knownViolations.contains(file.path)) continue;
    if (pattern.hasMatch(file.content)) violations.add(file.path);
  }

  expect(violations, isEmpty, reason: '$reason\n${violations.join('\n')}');
}
