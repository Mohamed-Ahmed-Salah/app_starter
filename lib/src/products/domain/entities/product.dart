import 'package:app_starter/core/utils/localized_text.dart';

/// Reference entity for the `products` example feature. Plain Dart: no
/// Flutter imports, no JSON — the model in `data/models/` does the parsing.
class Product {
  const Product({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.price,
    required this.currency,
  });

  final int id;
  final String nameEn;
  final String nameAr;
  final num price;
  final String currency;

  /// Prefer the active language, fall back to the other.
  String name({required bool isEn}) =>
      LocalizedText.pick(isEn: isEn, en: nameEn, ar: nameAr) ?? '';
}
