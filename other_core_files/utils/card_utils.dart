import 'package:attendance/core/config/enums.dart';
import 'package:attendance/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

class CardUtils {
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.nameRequired;
    }

    var fullName = value.split(RegExp(r' ')).where((el) => el != '');
    if (fullName.length < 2) {
      return AppLocalizations.of(context)?.bothNamesRequired;
    }

    return null;
  }

  static String? validateCardNum(String? input, BuildContext context) {
    if (input == null || input.isEmpty) {
      return AppLocalizations.of(context)?.cardNumberRequired;
    }

    String cardNumber = getCleanedNumber(input);

    if (input.length < 8 || !isValidLuhn(cardNumber)) {
      return AppLocalizations.of(context)?.invalidCardNumber;
    }

    return null;
  }

  static String? validateDate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.expiryRequired;
    }

    if (!value.contains(RegExp(r'(/)'))) {
      return AppLocalizations.of(context)?.invalidExpiry;
    }

    var split = value.split(RegExp(r'(/)'));

    int month = int.parse(split[0]);
    int year = int.parse(split[1]);

    if ((month < 1) || (month > 12)) {
      return AppLocalizations.of(context)?.invalidExpiry;
    }

    final expiryDate = DateTime(convertYearTo4Digits(year), month);
    final now = DateTime.now();

    if (expiryDate.isBefore(now)) {
      return AppLocalizations.of(context)?.expiredCard;
    }

    return null;
  }

  static String? validateCVC(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)?.cvcRequired;
    }

    if (value.length < 3 || value.length > 4) {
      return AppLocalizations.of(context)?.invalidCvc;
    }

    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  // static List<String> getExpiryDate(String value) {
  //   var split = value.split(RegExp(r'(/)'));
  //   return [split[0].trim(), split[1].trim()];
  // }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r'[^0-9]');
    return text.replaceAll(regExp, '');
  }

  static String getFormattedExpiryDate(String date) {
    var buffer = StringBuffer();

    for (int i = 0; i < date.length; i++) {
      buffer.write(date[i]);
      int nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != date.length) {
        buffer.write(' / ');
      }
    }

    return buffer.toString();
  }

  static bool isValidLuhn(String cardNumber) {
    int sum = 0;
    int length = cardNumber.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(cardNumber[length - i - 1]);

      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return true;
    }

    return false;
  }

  static String getFormattedCardNumber(String number) {
    final company = getCardCompanyFromNumber(number);

    var buffer = StringBuffer();

    if (company == CardCompany.amex) {
      for (int i = 0; i < number.length; i++) {
        buffer.write(number[i]);
        int nonZeroIndex = i + 1;
        if ((nonZeroIndex == 4 || nonZeroIndex == 11) &&
            nonZeroIndex != number.length) {
          buffer.write('  ');
        }
      }
    } else {
      for (int i = 0; i < number.length; i++) {
        buffer.write(number[i]);
        int nonZeroIndex = i + 1;
        if (nonZeroIndex % 4 == 0 && nonZeroIndex != number.length) {
          buffer.write('  ');
        }
      }
    }
    return buffer.toString();
  }

  static CardCompany getCardCompanyFromNumber(String input) {
    if (input.startsWith(
      RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))',
      ),
    )) {
      return CardCompany.master;
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      return CardCompany.amex;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      return CardCompany.visa;
    }
    return CardCompany.visa;
  }
}
