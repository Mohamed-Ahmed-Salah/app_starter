import 'package:flutter/widgets.dart';
import 'package:app_starter/core/constants/text_constants.dart';
import 'package:app_starter/l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  /// `true` when the active locale is English. Reads [AppLocalizations] so any
  /// widget using it rebuilds when the locale changes.
  bool get isEn =>
      AppLocalizations.of(this)?.localeName == TextConstants.englishLangCode;
}
