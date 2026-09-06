import 'package:flutter_bloc/flutter_bloc.dart';

/// Base interface for feature-based BlocProvider registries.
///
/// Each feature module should implement this interface to register
/// its BlocProviders in a modular and testable way.
///
/// Example:
/// ```dart
/// class AuthProvidersRegistry implements BlocProviderRegistry {
///   @override
///   List<BlocProvider> get providers => [
///     BlocProvider<LoginCubit>(create: (_) => LoginCubit(...)),
///     BlocProvider<RegisterCubit>(create: (_) => RegisterCubit(...)),
///   ];
/// }
/// ```
abstract class BlocProviderRegistry {
  /// Returns the list of BlocProviders for this feature module.
  List<BlocProvider> get providers;
}
