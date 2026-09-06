import 'package:app_starter/core/constants/network_constants.dart';
import 'package:app_starter/core/mixins/network_handler.dart';
import 'package:app_starter/src/products/data/models/product_model.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'products_remote_datasrc.dart';

/// Registered *as* the interface, so `sl<ProductsRemoteDataSrc>()` and any
/// constructor parameter typed `ProductsRemoteDataSrc` resolve to this.
/// The `Dio` comes from `RegisterModule.dio`.
@LazySingleton(as: ProductsRemoteDataSrc)
class ProductsRemoteDataSrcImpl
    with NetworkCallHandler
    implements ProductsRemoteDataSrc {
  const ProductsRemoteDataSrcImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<Product>> getAll() => handleNetworkCall<List<Product>>(
    call: () => _dio.get('/products'),
    onSuccess: (response) {
      final data = response.data[NetworkConstants.dataParam] as List;
      return data
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    },
  );
}
