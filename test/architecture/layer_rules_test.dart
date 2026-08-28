import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

/// The dependency rules of the four layers.
///
/// `common` is cross-cutting and must stay at the bottom; `data` and `domain` never
/// reach up into the UI; `presentation` goes through `domain` rather than talking to
/// repositories itself.
void main() {
  test('Given the common layer, '
      'when its imports are inspected, '
      'then it depends on no other layer', () {
    expectNoImport(fromLayer: 'common', toLayer: 'data');
    expectNoImport(fromLayer: 'common', toLayer: 'domain');
    expectNoImport(fromLayer: 'common', toLayer: 'presentation');
  });

  test('Given the data layer, '
      'when its imports are inspected, '
      'then it never reaches into the presentation layer', () {
    expectNoImport(fromLayer: 'data', toLayer: 'presentation');
  });

  test('Given the domain layer, '
      'when its imports are inspected, '
      'then it never reaches into the presentation layer', () {
    expectNoImport(fromLayer: 'domain', toLayer: 'presentation');
  });

  test('Given the presentation layer, '
      'when its imports are inspected, '
      'then it goes through domain services instead of touching repositories', () {
    expectNoImport(fromLayer: 'presentation', toLayer: 'data');
  });
}
