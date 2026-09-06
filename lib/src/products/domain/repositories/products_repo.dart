import 'package:app_starter/core/config/typedefs.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';

abstract class ProductsRepo {
  ResultFuture<List<Product>> getAll();
}
