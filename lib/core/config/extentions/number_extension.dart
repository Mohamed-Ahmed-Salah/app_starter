import 'package:intl/intl.dart';

extension NumberX on num {
  /// `12,880` — thousands separated, no decimals. For countable figures such as
  /// BV points, where fractions are noise.
  String get asCount => NumberFormat('#,##0').format(this);
}
