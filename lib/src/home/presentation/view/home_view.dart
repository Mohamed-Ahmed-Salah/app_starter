import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/size_constants.dart';
import '../../../../core/res/media.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../language/presentation/view/language_view.dart';
import '../../../products/presentation/view/products_view.dart';

/// Placeholder landing screen. Shows the [Media] icon and image pattern so
/// there is something to see; replace with the real home.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String path = '/home';
  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(text?.appName ?? 'App Starter')),
      body: Padding(
        padding: const EdgeInsets.all(SizeConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Media.infoOutlineIcon,
                  size: SizeConstants.iconSizeLarge,
                ),
                const SizedBox(width: SizeConstants.itemGapSmall),
                Expanded(
                  child: Text(
                    'Core is wired. Delete the placeholders in Media and build.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SizeConstants.sectionGap),
            ClipRRect(
              borderRadius: BorderRadius.circular(SizeConstants.radiusXl),
              child: Image.asset(Media.placeholder1Img),
            ),
            const SizedBox(height: SizeConstants.sectionGap),
            ElevatedButton(
              onPressed: () => context.goNamed(ProductsView.name),
              child: Text(text?.products ?? 'Products'),
            ),
            const SizedBox(height: SizeConstants.itemGap),
            OutlinedButton(
              onPressed: () => context.goNamed(LanguageView.name),
              child: Text(text?.languageTitle ?? 'Language'),
            ),
          ],
        ),
      ),
    );
  }
}
