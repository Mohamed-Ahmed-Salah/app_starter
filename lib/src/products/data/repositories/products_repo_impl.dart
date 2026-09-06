import 'package:app_starter/core/config/typedefs.dart';
import 'package:app_starter/core/mixins/error_handler.dart';
import 'package:app_starter/src/products/data/datasources/products_remote_datasrc.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';
import 'package:app_starter/src/products/domain/repositories/products_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductsRepo)
class ProductsRepoImpl with ErrorHandler implements ProductsRepo {
  const ProductsRepoImpl(this._remoteDataSource);
  final ProductsRemoteDataSrc _remoteDataSource;

  @override
  ResultFuture<List<Product>> getAll() =>
      handleRepoCall(() => _remoteDataSource.getAll());
}
