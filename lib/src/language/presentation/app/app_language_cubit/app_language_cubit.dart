import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/services/cache_service.dart';

part 'app_language_state.dart';
part 'app_language_cubit.freezed.dart';

/// Holds the app locale for the whole session. Provided app-wide from
/// `AppWideProviderRegistry`; `main.dart` feeds `state.locale` into
/// `MaterialApp.locale`, so a change here re-renders the app.
@lazySingleton
class AppLanguageCubit extends Cubit<AppLanguageState> {
  AppLanguageCubit({required CacheService cacheService})
    : _cacheService = cacheService,
      super(const AppLanguageState.initial(null));

  final CacheService _cacheService;

  Future<void> getLanguage() async {
    final saved = await _cacheService.getLanguage();
    emit(AppLanguageState.initial(saved == null ? null : Locale(saved)));
  }

  Future<void> changeLanguage({required String newLanguage}) async {
    final locale = Locale(newLanguage);
    if (locale == state.locale) return;
    await _cacheService.setLanguage(newLanguage);
    emit(AppLanguageState.initial(locale));
  }
}
