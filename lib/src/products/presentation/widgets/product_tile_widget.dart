import 'package:app_starter/core/config/extentions/context_extension.dart';
import 'package:app_starter/core/constants/size_constants.dart';
import 'package:app_starter/src/products/domain/entities/extensions/product_extension.dart';
import 'package:app_starter/src/products/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductTileWidget extends StatelessWidget {
  const ProductTileWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SizeConstants.itemGapSmall),
      child: Row(
        children: [
          Expanded(
            child: Text(
              product.name(isEn: context.isEn),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: SizeConstants.itemGap),
          Text(product.priceLabel, style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
