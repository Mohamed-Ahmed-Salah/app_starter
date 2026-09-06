import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/extentions/context_extension.dart';
import '../../../../core/constants/size_constants.dart';
import '../../../../core/constants/text_constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../app/app_language_cubit/app_language_cubit.dart';

/// Picks the app language. The cubit is app-wide (see
/// `AppWideProviderRegistry`), so this screen only reads and writes it.
class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  static const String path = '/language';
  static const String name = 'language';

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    // Selected = the saved choice, else whatever locale the app resolved to.
    final current =
        context.watch<AppLanguageCubit>().state.locale?.languageCode ??
        (context.isEn
            ? TextConstants.englishLangCode
            : TextConstants.arabicLangCode);

    return Scaffold(
      appBar: AppBar(title: Text(text?.languageTitle ?? 'Language')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeConstants.screenPadding,
        ),
        child: RadioGroup<String>(
          groupValue: current,
          onChanged: (value) {
            if (value == null) return;
            context.read<AppLanguageCubit>().changeLanguage(newLanguage: value);
          },
          child: Column(
            children: [
              RadioListTile<String>(
                value: TextConstants.englishLangCode,
                title: Text(text?.english ?? 'English'),
              ),
              RadioListTile<String>(
                value: TextConstants.arabicLangCode,
                title: Text(text?.arabic ?? 'العربية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
