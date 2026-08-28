import 'package:flutter/widgets.dart';
import 'package:workspace_flow/common/translation/app_localizations.dart';

/// Shorthand for the generated localizations: `context.translations.projects_label`.
extension TranslationExtension on BuildContext {
  AppLocalizations get translations => AppLocalizations.of(this);
}
