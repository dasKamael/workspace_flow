import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

/// A file's suffix promises what is inside it.
void main() {
  test('Given the role suffixes of the codebase, '
      'when each file is inspected, '
      'then it declares the type its name promises', () {
    expectDeclarationForSuffix(
      suffix: 'repository',
      pattern: RegExp(r'class \w*Repository\b'),
      description: 'declare a class ending in "Repository"',
    );
    expectDeclarationForSuffix(
      suffix: 'dao',
      pattern: RegExp(r'class \w*Dao\b'),
      description: 'declare a class ending in "Dao"',
    );
    expectDeclarationForSuffix(
      suffix: 'tables',
      pattern: RegExp(r'extends Table\b'),
      description: 'declare at least one drift table',
    );
    expectDeclarationForSuffix(
      suffix: 'controller',
      pattern: RegExp(r'class \w*Controller\b'),
      description: 'declare a class ending in "Controller"',
    );
    expectDeclarationForSuffix(
      suffix: 'screen',
      pattern: RegExp(r'class \w*Screen\b'),
      description: 'declare a class ending in "Screen"',
    );
    expectDeclarationForSuffix(
      suffix: 'state',
      pattern: RegExp(r'class \w*State\b'),
      description: 'declare a class ending in "State"',
    );
    expectDeclarationForSuffix(
      suffix: 'entity_mapper',
      pattern: RegExp(r'class \w*Mapper\b'),
      description: 'declare a class ending in "Mapper"',
    );
    expectDeclarationForSuffix(
      suffix: 'channel',
      pattern: RegExp(r'class \w*Channel\b'),
      description: 'declare a class ending in "Channel"',
    );
    expectDeclarationForSuffix(
      suffix: 'util',
      pattern: RegExp(r'class \w*Util\b'),
      description: 'declare a class ending in "Util"',
    );
    expectDeclarationForSuffix(
      suffix: 'color_palette',
      pattern: RegExp(r'class \w*ColorPalette\b'),
      description: 'declare a class ending in "ColorPalette"',
    );
    expectDeclarationForSuffix(suffix: 'enum', pattern: RegExp(r'enum \w+'), description: 'declare an enum');
    expectDeclarationForSuffix(
      suffix: 'extension',
      pattern: RegExp(r'extension \w+'),
      description: 'declare an extension',
    );
  });
}
