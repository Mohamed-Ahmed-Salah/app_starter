import 'package:attendance/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Formats the DateTime object into a string like "Mon Dec 25 2023".
  ///
  /// Example:
  /// final myDate = DateTime.now();
  /// print(myDate.toFriendlyFormat()); // e.g., "Tue Aug 26 2025"
  String toAttendanceFormat() {
    // Create a DateFormat object with your desired format.
    final DateFormat formatter = DateFormat('E MMM d y');
    // Use the formatter on the current DateTime instance ('this').
    return formatter.format(this);
  }

  bool get isAm {
    return hour < 12;
  }

  String toDateWithSlash() {
    return "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year";
  }

  String toYyyyMmDd() {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  String toHHmm() {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String cardDate(AppLocalizations? text) {
    return "${toHHmm()} ${isAm ? text?.am : text?.pm} - ${toDateWithSlash()}";
  }

  bool isSameDate(DateTime b) {
    return year == b.year && month == b.month && day == b.day;
  }

  String formatDateRange(DateTime to) {
    final monthDay = DateFormat('MMM d'); // e.g. Oct 9
    final dayOnly = DateFormat('d'); // e.g. 11

    if (month == to.month && year == to.year) {
      // Same month & year → Oct 9-11
      return '${monthDay.format(this)}-${dayOnly.format(to)}';
    } else {
      // Different month or year → Oct 9 - Nov 10
      return '${monthDay.format(this)} - ${monthDay.format(to)}';
    }
  }

  String toHomeFormat() {
    return DateFormat('EEE, MMM d yyyy').format(this);
  }

  String toHomeFormatWithoutWeekday() {
    return DateFormat('MMM d yyyy').format(this);
  }

  String dayName(String local) {
    return DateFormat.E(local).format(this);
  }
}
