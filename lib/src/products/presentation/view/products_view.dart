import 'package:app_starter/core/config/extentions/failure_extension.dart';
import 'package:app_starter/core/constants/size_constants.dart';
import 'package:app_starter/core/services/injection_container.dart';
import 'package:app_starter/core/utils/util_functions.dart';
import 'package:app_starter/l10n/app_localizations.dart';
import 'package:app_starter/src/products/presentation/app/get_products_cubit/get_products_cubit.dart';
import 'package:app_starter/src/products/presentation/widgets/product_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reference screen: the public widget provides the cubit from `sl`, the
/// private body consumes it. Everything behind `sl<GetProductsCubit>()` —
/// usecase, repo, datasource, Dio — is resolved by the generated registration.
class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  static const String path = '/products';
  static const String name = 'products';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetProductsCubit>(
      create: (_) => sl<GetProductsCubit>()..getProducts(),
      child: const _ProductsViewBody(),
    );
  }
}

class _ProductsViewBody extends StatelessWidget {
  const _ProductsViewBody();

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return BlocListener<GetProductsCubit, GetProductsState>(
      listener: (context, state) => state.whenOrNull(
        failed: (failure) => UtilFunctions.showFailedToast(
          message: failure.getFailureMessage(context),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(text?.products ?? 'Products')),
        body: BlocBuilder<GetProductsCubit, GetProductsState>(
          builder: (context, state) => state.maybeWhen(
            success: (products) => ListView.builder(
              padding: const EdgeInsets.all(SizeConstants.screenPadding),
              itemCount: products.length,
              itemBuilder: (_, i) => ProductTileWidget(product: products[i]),
            ),
            failed: (_) => Center(
              child: TextButton(
                onPressed: () => context.read<GetProductsCubit>().getProducts(),
                child: Text(text?.retry ?? 'Retry'),
              ),
            ),
            orElse: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
