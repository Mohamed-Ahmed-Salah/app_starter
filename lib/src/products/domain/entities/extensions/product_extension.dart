import 'package:app_starter/core/config/extentions/money_extension.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';

/// Presentation helpers for [Product]. Lives beside the entity, not in
/// `core/` — see the `flutter-clean-arch` skill, "Entity Extensions".
extension ProductX on Product {
  /// `SAR 12,880.00`
  String get priceLabel => price.withCurrency(currency);
}
