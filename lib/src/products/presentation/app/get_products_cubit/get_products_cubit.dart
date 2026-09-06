import 'package:app_starter/core/errors/failures.dart';
import 'package:app_starter/core/utils/util_functions.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';
import 'package:app_starter/src/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'get_products_state.dart';
part 'get_products_cubit.freezed.dart';

/// `@injectable` = a fresh instance on every `sl<GetProductsCubit>()`, so
/// each screen that provides it gets its own state.
@injectable
class GetProductsCubit extends Cubit<GetProductsState> {
  GetProductsCubit({required GetProductsUsecase getProductsUsecase})
    : _getProductsUsecase = getProductsUsecase,
      super(const GetProductsState.initial());

  final GetProductsUsecase _getProductsUsecase;

  Future<void> getProducts() async {
    UtilFunctions.appLog('getProducts:');
    emit(const GetProductsState.loading());

    final result = await _getProductsUsecase();

    result.fold(
      (failure) => emit(GetProductsState.failed(failure: failure)),
      (products) => emit(GetProductsState.success(products: products)),
    );
  }
}
