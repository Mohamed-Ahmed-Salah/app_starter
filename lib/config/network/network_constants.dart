import 'package:app_starter/config/services/cache_service.dart';
import 'package:app_starter/config/services/injection_container.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkConstants {
  static String devUrl = 'https://attendanceapi.eventsmar.net/api/v1';
  static String releaseUrl = 'https://attendanceapi.eventsmar.net/api/v1';
  static String url = kReleaseMode ? releaseUrl : devUrl;
  static const String successParam = "success";
  static const String dataParam = "data";
  static const String errorsListParam = "errors";
  static const String messageParam = "message";
  static const String statusCode = "status";

  static const headers = {'Content-Type': 'application/json; charset=UTF-8'};
  static const pageSize = 10;
  static const timeout = 20;

  /// in seconds
  static const minimumFetchInterval = 24;

  /// in hours

  static Future<Map<String, String>> getHeaders({
    String contentType = "application/json",
  }) async {
    Map<String, String> headers = <String, String>{
      "Cache-Control": "no-cache",
      "Content-Type": contentType,
      "Accept": contentType,
    };
    return headers;
  }

  static Future<Map<String, String>> getHeadersWithAuth({
    String contentType = "application/json",
  }) async {
    final token = await sl<CacheService>().getSessionToken() ?? "";
    final language = sl<CacheService>().getLanguage() ?? "en";
    Map<String, String> headers = <String, String>{
      "Cache-Control": "no-cache",
      "Content-Type": contentType,
      "token": "Bearer $token",
      "language": language,
      "Accept": contentType,
    };
    return headers;
  }
}
