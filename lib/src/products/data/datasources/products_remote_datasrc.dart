import 'package:app_starter/src/products/domain/entities/product.dart';

abstract interface class ProductsRemoteDataSrc {
  Future<List<Product>> getAll();
}
