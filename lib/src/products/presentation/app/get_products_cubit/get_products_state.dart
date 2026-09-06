part of 'get_products_cubit.dart';

@freezed
sealed class GetProductsState with _$GetProductsState {
  const factory GetProductsState.initial() = _initialState;
  const factory GetProductsState.loading() = _loadingState;
  const factory GetProductsState.failed({required Failure failure}) =
      _failedState;
  const factory GetProductsState.success({required List<Product> products}) =
      _successState;
}
