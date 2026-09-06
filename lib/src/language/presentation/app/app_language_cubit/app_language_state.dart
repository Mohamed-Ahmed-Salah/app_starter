part of 'app_language_cubit.dart';

@freezed
sealed class AppLanguageState with _$AppLanguageState {
  /// `null` locale = follow the device until the user picks one.
  const factory AppLanguageState.initial(Locale? locale) = _initialState;
}
