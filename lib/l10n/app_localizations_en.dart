// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'App Starter';

  @override
  String get errorNoInternet => 'Connection Error. Please try again';

  @override
  String get errorParsing =>
      'We couldn’t load the information. Please try again or contact support if the issue continues.';

  @override
  String get errorTimeout => 'Request Timed out. Please try again';

  @override
  String get errorUnknown => 'Something Went Wrong. Please Contact Support';

  @override
  String get requiredField => 'This field is required';

  @override
  String get fieldOnlyNumbers => 'This field must only contain numbers';

  @override
  String get onlyNineNumber => 'This field should contain 9 numbers';

  @override
  String get amountMustBePositive => 'Enter an amount greater than zero';

  @override
  String get amountExceedsBalance => 'Amount exceeds your available balance';

  @override
  String get enterValidEmail => 'Please enter a valid Email';

  @override
  String get enterFullName => 'Please enter full name';

  @override
  String get enterValidFullName => 'Please enter valid full name';

  @override
  String get enterNameWithNoNumber =>
      'Please enter valid full name with no numbers';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters long.';

  @override
  String get passwordMissingNumber =>
      'Password must include at least one number.';

  @override
  String get passwordEnOnly => 'This field must contain only English letters.';

  @override
  String get passwordConfirmationMessage =>
      'The passwords do not match. Please try again.';

  @override
  String get failureDialogTitle => 'Sorry';

  @override
  String get warningDialogTitle => 'Warning';

  @override
  String get infoDialogTitle => 'Heads up';

  @override
  String get products => 'Products';

  @override
  String get retry => 'Retry';

  @override
  String get couldntStartApp => 'Couldn\'t start the app. Please try again.';

  @override
  String get updateRequiredTitle => 'Update required';

  @override
  String get updateRequiredBody =>
      'This version is no longer supported. Please update to continue.';

  @override
  String get updateNow => 'Update now';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get getStarted => 'Get started';

  @override
  String get languageTitle => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';
}
