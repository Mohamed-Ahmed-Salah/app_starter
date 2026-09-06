import 'package:intl/intl.dart';

/// Shared date formats. Every date the UI renders goes through one of these so
/// the app reads consistently and honours the active locale — `DateFormat`
/// falls back to English month and day names when [locale] is omitted.
///
/// Callers pass `AppLocalizations.of(context)?.localeName`.
extension DateTimeX on DateTime {
  /// `27 May`
  String dayMonth({String? locale}) => DateFormat('d MMM', locale).format(this);

  /// `27 May 2026`
  String dayMonthYear({String? locale}) =>
      DateFormat('d MMM yyyy', locale).format(this);

  /// `Tuesday, 27 May`
  String weekdayDayMonth({String? locale}) =>
      DateFormat('EEEE, d MMMM', locale).format(this);

  /// `2026-05-27` — the date-only form the API takes in query filters. Never
  /// localised: it is sent, not shown.
  String get asApiDate => DateFormat('yyyy-MM-dd').format(this);
}

extension DateStringX on String? {
  /// Parses an ISO-8601 date from the API, `null` when absent or malformed.
  DateTime? get asDate {
    final value = this;
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  /// [DateTimeX.dayMonthYear] straight from an API date string. A value that
  /// will not parse is passed through as it arrived, so a contract change shows
  /// on screen instead of vanishing.
  String? asDayMonthYear({String? locale}) {
    final value = this;
    if (value == null || value.isEmpty) return null;
    return asDate?.dayMonthYear(locale: locale) ?? value;
  }
}
