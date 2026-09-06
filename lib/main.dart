import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

import 'core/config/app_configuration.dart';
import 'core/config/app_theme_config.dart';
import 'core/providers/app_providers.dart';
import 'core/router.dart';
import 'core/services/injection_container.dart';
import 'flavors.dart';
import 'src/language/presentation/app/app_language_cubit/app_language_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: ToastificationWrapper(
        child: MultiBlocProvider(
          providers: AppProviders.all,
          // Rebuilds the whole app when the language changes.
          child: BlocBuilder<AppLanguageCubit, AppLanguageState>(
            builder: (context, state) => MaterialApp.router(
              builder: AppConfiguration.builder,
              routerConfig: router,
              supportedLocales: AppConfiguration.supportedLocales,
              localizationsDelegates: AppConfiguration.localizationsDelegates,
              locale: state.locale,
              title: F.title,
              scaffoldMessengerKey: scaffoldKey,
              debugShowCheckedModeBanner: false,
              theme: AppThemeConfig.instance.appTheme,
              themeMode: ThemeMode.light,
            ),
          ),
        ),
      ),
    );
  }
}
