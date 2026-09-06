import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:app_starter/l10n/app_localizations.dart';

abstract class TextFormValidation {
  TextFormValidation._();

  static const _emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

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

  static String? requiredField(String? value, {required BuildContext context}) {
    if (value == null ||
        value.isEmpty ||
        ((value is Iterable || value is Map) && value.isEmpty)) {
      return "${AppLocalizations.of(context)?.requiredField}";
    }
    return null;
  }

  /// Validates a monetary amount: required, numeric, greater than zero, and —
  /// when [max] is provided — not above the available balance.
  static String? amountValidation(
    String? value, {
    required BuildContext context,
    num? max,
  }) {
    final local = AppLocalizations.of(context);
    if (value == null || value.trim().isEmpty) {
      return requiredField(value, context: context);
    }
    final amount = num.tryParse(value.trim());
    if (amount == null) {
      return local?.fieldOnlyNumbers ?? "This field must contain only numbers";
    }
    if (amount <= 0) {
      return local?.amountMustBePositive ??
          "Enter an amount greater than zero";
    }
    if (max != null && amount > max) {
      return local?.amountExceedsBalance ??
          "Amount exceeds your available balance";
    }
    return null;
  }


  static String? optionalEmailValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value!.isEmpty) return null;
    RegExp regex = RegExp(_emailPattern);
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
    RegExp regex = RegExp(_emailPattern);
    if (!(regex.hasMatch(value))) {
      return "${AppLocalizations.of(context)?.enterValidEmail}";
    }
    return null;
  }

  static String? fullNameValidation(
    String? value, {
    required BuildContext context,
  }) {
    if (value == null || value.isEmpty) {
      return requiredField(value, context: context);
    }

    bool hasNumbers = RegExp(r'[0-9]').hasMatch(value);
    bool hasNumbersAr = RegExp(r'[٠-٩]').hasMatch(value);

    bool hasSpecialChar = RegExp(
      r'[!@#%^&*(),.?":{}|<>+=\[\]]',
    ).hasMatch(value);

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
    }
    if (!regExp.hasMatch(value)) {
      return "${AppLocalizations.of(context)?.enterValidFullName}";
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
    if (!isValidLength) {
      return local?.passwordTooShort ??
          "Password must be at least 8 characters long";
    }
    // final bool hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(value);
    // if (!hasCapitalLetter) {
    //   return local?.passwordMissingUppercase ??
    //       "Password must include at least one uppercase letter.";
    // }
    final bool hasNumber = RegExp(r'\d').hasMatch(value);
    if (!hasNumber) {
      return local?.passwordMissingNumber ??
          "Password must include at least one number.";
    }

    final bool hasNoEmojis = !RegExp(
      r'[\u{1F300}-\u{1F5FF}\u{1F900}-\u{1F9FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F191}-\u{1F251}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{3030}\u{2B50}\u{2B55}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{3297}\u{3299}\u{303D}\u{00A9}\u{00AE}\u{2122}\u{23F3}\u{24C2}\u{23E9}-\u{23EF}\u{25B6}\u{23F8}-\u{23FA}]',
      unicode: true,
    ).hasMatch(value);
    if (!hasNoEmojis) {
      return local?.passwordEnOnly ??
          "This field must contain only English letters.";
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

  static final englishAndArabic = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\u0600-\u06FF\s]"),
  );
  static final passwordAllowedText = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{}|;:',.<>?/~`\\\s]"),
  );

  static final usernameAllowedText = FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9._]"),
  );

}
