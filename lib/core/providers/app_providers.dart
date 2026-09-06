import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_wide_provider.dart';
import 'bloc_provider_registry.dart';

/// App-wide BlocProviders mounted above `MaterialApp` in main.dart.
///
/// One [BlocProviderRegistry] per feature (`core/providers/<feature>_providers.dart`),
/// spread here. Keep it to cubits that genuinely live for the whole session;
/// screen-scoped cubits are provided by the screen that owns them.
class AppProviders {
  static List<BlocProvider> get all => [
    ...AppWideProviderRegistry().providers,
    // ...AuthProvidersRegistry().providers,
  ];
}
