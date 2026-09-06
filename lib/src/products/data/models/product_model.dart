import 'package:app_starter/src/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.price,
    required super.currency,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as int,
    nameEn: json['name'] as String? ?? '',
    nameAr: json['name_ar'] as String? ?? '',
    price: json['price'] as num? ?? 0,
    currency: json['currency'] as String? ?? '',
  );
}
