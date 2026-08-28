import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

/// Where a role is allowed to live.
void main() {
  test('Given the UI roles, '
      'when their files are located, '
      'then they live in the presentation layer', () {
    expectSuffixOnlyIn(suffix: 'screen', allowedDirectory: 'presentation');
    expectSuffixOnlyIn(suffix: 'controller', allowedDirectory: 'presentation');
    expectSuffixOnlyIn(suffix: 'state', allowedDirectory: 'presentation');
  });

  test('Given the persistence roles, '
      'when their files are located, '
      'then they live in the data layer', () {
    expectSuffixOnlyIn(suffix: 'repository', allowedDirectory: 'data');
    expectSuffixOnlyIn(suffix: 'dao', allowedDirectory: 'data');
    expectSuffixOnlyIn(suffix: 'tables', allowedDirectory: 'data');
    expectSuffixOnlyIn(suffix: 'entity_mapper', allowedDirectory: 'data');
  });

  test('Given the domain roles, '
      'when their files are located, '
      'then services live in the domain layer', () {
    expectSuffixOnlyIn(suffix: 'service', allowedDirectory: 'domain');
  });
}
