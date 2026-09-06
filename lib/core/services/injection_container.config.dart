// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:app_starter/core/monitoring/analytics_facade.dart' as _i159;
import 'package:app_starter/core/monitoring/firebase_analytics_client.dart'
    as _i798;
import 'package:app_starter/core/services/auth_event_handler_service.dart'
    as _i500;
import 'package:app_starter/core/services/cache_service.dart' as _i437;
import 'package:app_starter/core/services/firebase_remote_config_service.dart'
    as _i626;
import 'package:app_starter/core/services/in_app_review_service.dart' as _i1059;
import 'package:app_starter/core/services/logout_service.dart' as _i1052;
import 'package:app_starter/core/services/register_module.dart' as _i19;
import 'package:app_starter/src/language/presentation/app/app_language_cubit/app_language_cubit.dart'
    as _i993;
import 'package:app_starter/src/products/data/datasources/products_remote_datasrc.dart'
    as _i704;
import 'package:app_starter/src/products/data/datasources/products_remote_datasrc_impl.dart'
    as _i645;
import 'package:app_starter/src/products/data/repositories/products_repo_impl.dart'
    as _i559;
import 'package:app_starter/src/products/domain/repositories/products_repo.dart'
    as _i248;
import 'package:app_starter/src/products/domain/usecases/get_products_usecase.dart'
    as _i909;
import 'package:app_starter/src/products/presentation/app/get_products_cubit/get_products_cubit.dart'
    as _i759;
import 'package:app_starter/src/splash/presentation/app/app_redirection_bloc/app_redirection_bloc.dart'
    as _i315;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:in_app_review/in_app_review.dart' as _i553;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i798.FirebaseAnalyticsClient>(
      () => _i798.FirebaseAnalyticsClient(),
    );
    gh.lazySingleton<_i626.FirebaseRemoteConfigService>(
      () => _i626.FirebaseRemoteConfigService(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i553.InAppReview>(() => registerModule.inAppReview);
    gh.lazySingleton<_i159.AnalyticsFacade>(
      () => registerModule.analyticsFacade(gh<_i798.FirebaseAnalyticsClient>()),
    );
    gh.lazySingleton<_i437.CacheService>(
      () => _i437.CacheService(
        gh<_i558.FlutterSecureStorage>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.singleton<_i361.Dio>(() => registerModule.dio(gh<_i437.CacheService>()));
    gh.lazySingleton<_i1059.InAppReviewService>(
      () => _i1059.InAppReviewService(
        inAppReview: gh<_i553.InAppReview>(),
        cacheService: gh<_i437.CacheService>(),
      ),
    );
    gh.lazySingleton<_i1052.LogoutService>(
      () => _i1052.LogoutService(cacheService: gh<_i437.CacheService>()),
    );
    gh.lazySingleton<_i993.AppLanguageCubit>(
      () => _i993.AppLanguageCubit(cacheService: gh<_i437.CacheService>()),
    );
    gh.lazySingleton<_i704.ProductsRemoteDataSrc>(
      () => _i645.ProductsRemoteDataSrcImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i315.AppRedirectionBloc>(
      () => _i315.AppRedirectionBloc(
        cacheService: gh<_i437.CacheService>(),
        firebaseRemoteConfigService: gh<_i626.FirebaseRemoteConfigService>(),
      ),
    );
    gh.lazySingleton<_i500.AuthEventHandlerService>(
      () => _i500.AuthEventHandlerService(
        logoutService: gh<_i1052.LogoutService>(),
        cacheService: gh<_i437.CacheService>(),
      ),
    );
    gh.lazySingleton<_i248.ProductsRepo>(
      () => _i559.ProductsRepoImpl(gh<_i704.ProductsRemoteDataSrc>()),
    );
    gh.lazySingleton<_i909.GetProductsUsecase>(
      () => _i909.GetProductsUsecase(gh<_i248.ProductsRepo>()),
    );
    gh.factory<_i759.GetProductsCubit>(
      () => _i759.GetProductsCubit(
        getProductsUsecase: gh<_i909.GetProductsUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i19.RegisterModule {}
