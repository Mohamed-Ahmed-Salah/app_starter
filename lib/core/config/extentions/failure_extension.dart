import 'package:flutter/widgets.dart';
import 'package:app_starter/core/errors/failures.dart';
import 'package:app_starter/l10n/app_localizations.dart';

extension FailureExtension on Failure {
  /// The message to show the user for this failure: the backend's own copy
  /// for a [GeneralFailure], a localized generic line for everything else.
  String getFailureMessage(BuildContext context) {
    final text = AppLocalizations.of(context);

    if (this is GeneralFailure) {
      return errors.isEmpty ? message : "$message\n${errors.join('\n')}";
    }

    if (this is NoInternetFailure) {
      return text?.errorNoInternet ?? 'Connection Error. Please try again';
    }

    if (this is FormatParserFailure) {
      return text?.errorParsing ??
          "We couldn't load the information. Please try again or contact support if the issue continues.";
    }

    if (this is TimeOutFailure) {
      return text?.errorTimeout ?? 'Request Timed out. Please try again';
    }

    if (this is ServerFailure) {
      return text?.errorUnknown ??
          'Something Went Wrong. Please Contact Support';
    }

    return "$statusCode: $message";
  }
}
