import 'package:flutter_bloc/flutter_bloc.dart';

import '../../src/language/presentation/app/app_language_cubit/app_language_cubit.dart';
import '../../src/splash/presentation/app/app_redirection_bloc/app_redirection_bloc.dart';
import '../services/injection_container.dart';
import 'bloc_provider_registry.dart';

/// Blocs that live for the whole session and are needed before any screen.
class AppWideProviderRegistry implements BlocProviderRegistry {
  @override
  List<BlocProvider> get providers => [
    BlocProvider<AppLanguageCubit>(
      lazy: false,
      create: (_) => sl<AppLanguageCubit>()..getLanguage(),
    ),
    BlocProvider<AppRedirectionBloc>(
      lazy: false,
      create: (_) => sl<AppRedirectionBloc>()
        ..add(const AppRedirectionEvent.getAppDataAndRedirect()),
    ),
  ];
}
