import 'package:app_starter/core/config/typedefs.dart';
import 'package:app_starter/core/config/usecase.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';
import 'package:app_starter/src/products/domain/repositories/products_repo.dart';
import 'package:injectable/injectable.dart';

/// One shared, stateless instance. `ProductsRepo` is resolved to the impl
/// registered `as:` it.
@lazySingleton
class GetProductsUsecase extends UsecaseWithoutParams<List<Product>> {
  const GetProductsUsecase(this._repo);
  final ProductsRepo _repo;

  @override
  ResultFuture<List<Product>> call() => _repo.getAll();
}
