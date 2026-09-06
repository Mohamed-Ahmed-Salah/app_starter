import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../flavors.dart';
import '../constants/network_constants.dart';
import '../monitoring/analytics_facade.dart';
import '../monitoring/firebase_analytics_client.dart';
import '../network/auth_interceptor.dart';
import '../network/network_log_interceptor.dart';
import 'cache_service.dart';

/// Registrations `injectable` cannot derive from a class annotation: types we
/// don't own (SharedPreferences, Dio, …), async construction, and anything
/// that needs a hand-built argument such as a list of clients.
///
/// Our own services are annotated where they are declared, not listed here.
@module
abstract class RegisterModule {
  /// Awaited before anything else is registered, so [CacheService] can take
  /// the resolved instance in its constructor.
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  InAppReview get inAppReview => InAppReview.instance;

  @singleton
  Dio dio(CacheService cacheService) {
    final dio = Dio(
      BaseOptions(
        baseUrl: F.baseUrl,
        connectTimeout: const Duration(seconds: NetworkConstants.timeout),
        receiveTimeout: const Duration(seconds: NetworkConstants.timeout),
        headers: const {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
      ),
    );

    dio.interceptors
      ..add(AuthInterceptor(cacheService))
      // Logging goes last so it prints the headers AuthInterceptor attached.
      // Empty outside the dev flavor — see networkLogInterceptors().
      ..addAll(networkLogInterceptors());

    return dio;
  }

  /// Every analytics provider goes in this list. Add a new client here and
  /// nowhere else; cubits and widgets only ever see [AnalyticsFacade].
  @lazySingleton
  AnalyticsFacade analyticsFacade(FirebaseAnalyticsClient firebase) =>
      AnalyticsFacade([firebase]);
}
