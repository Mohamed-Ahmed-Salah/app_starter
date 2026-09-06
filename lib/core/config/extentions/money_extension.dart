import 'package:intl/intl.dart';

extension MoneyX on num {
  /// `SAR 12,880.00` — thousands separated, always two decimals, currency
  /// first. An absent currency drops the prefix rather than printing a space.
  String withCurrency(String? currency) {
    final amount = NumberFormat('#,##0.00').format(this);
    if (currency == null || currency.isEmpty) return amount;
    return '$currency $amount';
  }
}
