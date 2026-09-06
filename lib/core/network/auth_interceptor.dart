import 'package:dio/dio.dart';

import '../services/cache_service.dart';
import '../utils/util_functions.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._cacheService);

  final CacheService _cacheService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _cacheService.getSessionToken();
    final language = await _cacheService.getLanguage();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      UtilFunctions.appLog('TOKEN $token');
    }
    options.headers['language'] = language;

    handler.next(options);
  }
}
