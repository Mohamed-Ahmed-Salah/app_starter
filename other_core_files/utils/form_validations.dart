import 'package:attendance/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

abstract class TextFormValidation {
  TextFormValidation._();

  static String? phoneValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null) return requiredField("", context: context);
    if (value.isEmpty) return requiredField(value, context: context);
    if (!RegExp(r"^[0-9]+$|[.][0-9]+$").hasMatch(value)) {
      return "${AppLocalizations.of(context)?.fieldOnlyNumbers}";
    }
    if (value.length < 9) {
      return "${AppLocalizations.of(context)?.onlyNineNumber}";
    }
    return null;
  }

  static String? saudiPhoneValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null) return requiredField("", context: context);
    if (value.isEmpty) return requiredField(value, context: context);
    if (!RegExp(r"^[0-9]+$|[.][0-9]+$").hasMatch(value)) {
      return "${AppLocalizations.of(context)?.fieldOnlyNumbers}";
    }
    if (value.length < 12) {
      return "${AppLocalizations.of(context)?.onlyTwelveNumber}";
    }
    if (value.startsWith("0")) {
      return "${AppLocalizations.of(context)?.fieldDontStartWithZero}";
    }
    if (!value.startsWith("9665")) {
      return "${AppLocalizations.of(context)?.fieldShouldStartWithKsa}";
    }
    return null;
  }

  static String? requiredField(String? value, {required BuildContext context}) {
    if (value == null ||
        value.isEmpty ||
        ((value is Iterable || value is Map) && value.isEmpty)) {
      return "${AppLocalizations.of(context)?.requiredField}";
    }
    return null;
  }

  static String? requiredFieldNoMessage(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null ||
        value == false ||
        value.isEmpty ||
        ((value is Iterable || value is Map) && value.isEmpty)) {
      return "";
    }
    return null;
  }

  static String? optionalEmailValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value!.isEmpty) return null;
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!(regex.hasMatch(value))) {
      return "${AppLocalizations.of(context)?.enterValidEmail}";
    }
    return null;
  }

  static String? emailValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value!.isEmpty) return requiredField(value, context: context);
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!(regex.hasMatch(value))) {
      return "${AppLocalizations.of(context)?.enterValidEmail}";
    }
    return null;
  }

  static String? fullNameValidation(
    String? value, {
    required BuildContext context,
  }) {
    print("VALEUE ${value}");
    if (value == null || value.isEmpty) {
      return requiredField(value, context: context);
    }

    bool hasNumbers = RegExp(r'[0-9]').hasMatch(value);
    bool hasNumbersAr = RegExp(r'[٠-٩]').hasMatch(value);

    bool hasSpecialChar = RegExp(r'[!@#%^&*(),.?":{}|<>]').hasMatch(value);

    if (hasSpecialChar) {
      return "${AppLocalizations.of(context)?.enterValidFullName}";
    }

    if (hasNumbers || hasNumbersAr) {
      return "${AppLocalizations.of(context)?.enterNameWithNoNumber}";
    }
    String pattern = "[a-z\u0621-\u064a- ]";
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "${AppLocalizations.of(context)?.enterFullName}";
    } else if (!regExp.hasMatch(value)) {
      return "${AppLocalizations.of(context)?.enterValidFullName}";
    }
    return null;
  }

  static String? otpValidation(String? value, {required BuildContext context}) {
    if (value!.isEmpty) return requiredField(value, context: context);
    if (!RegExp(r"^[0-9]+$|[.][0-9]+$").hasMatch(value)) {
      return "${AppLocalizations.of(context)?.fieldOnlyNumbers}";
    }
    if (value.length < 4) {
      return "${AppLocalizations.of(context)?.onlyFourNumber}";
    }
    return null;
  }

  static String? passwordValidation(
    String? value, {
    required BuildContext context,
  }) {
    final local = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return local?.requiredField ?? "Required field";
    }

    // Password rules
    final bool isValidLength = value.length >= 8;
    final bool hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(value);
    final bool hasNumber = RegExp(r'\d').hasMatch(value);
    final bool hasSpecialChar = RegExp(
      r'[!@#$%^&*(),.?":{}|<>]',
    ).hasMatch(value);
    final bool isEnglishOnly = RegExp(
      r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>\s]+$',
    ).hasMatch(value);
    final bool hasNoEmojis = !RegExp(
      r'[\u{1F300}-\u{1F5FF}\u{1F900}-\u{1F9FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F191}-\u{1F251}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{3030}\u{2B50}\u{2B55}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{3297}\u{3299}\u{303D}\u{00A9}\u{00AE}\u{2122}\u{23F3}\u{24C2}\u{23E9}-\u{23EF}\u{25B6}\u{23F8}-\u{23FA}]',
      unicode: true,
    ).hasMatch(value);

    // If any rule fails, return a single message
    if (!isValidLength ||
        !hasCapitalLetter ||
        !hasNumber ||
        !hasSpecialChar ||
        !isEnglishOnly ||
        !hasNoEmojis) {
      return local?.passwordRequirements ??
          "Password must be at least 8 characters long, include an uppercase letter, a number, a special character, and contain only English letters and symbols.";
    }

    return null;
  }

  static String? passwordConfirmationValidation(
    String? value, {
    required String password,
    required BuildContext context,
  }) {
    final String? message = passwordValidation(value, context: context);
    if (message != null) {
      return message;
    }
    final local = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return local?.requiredField ?? "Required field";
    }

    if (value != password) {
      return local?.passwordConfirmationMessage ?? "Passwords do not match";
    }

    return null;
  }

  static int calculatePasswordStrength(String? password) {
    if (password == null || password.isEmpty) return 0;

    int strength = 0;

    if (password.length >= 6) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) {
      strength++;
    }

    return strength; // 0 to 4
  }
}
