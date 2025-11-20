import 'package:attendance/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

extension ContextExtention on BuildContext {
  bool get isEn {
    return AppLocalizations.of(this)?.localeName == "en";
  }
}
