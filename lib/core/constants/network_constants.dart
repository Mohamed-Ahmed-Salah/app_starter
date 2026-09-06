import '../services/cache_service.dart';
import '../services/injection_container.dart';
import '../utils/util_functions.dart';

abstract class NetworkConstants {
  // TODO(starter): point these at your API. `F.baseUrl` picks one per flavor.
  static String devUrl = "https://dev.example.com/api/v1";
  static String prodUrl = "https://api.example.com/api/v1";

  static const String successParam = "success";
  static const String dataParam = "data";
  static const String errorsListParam = "errors";
  static const String messageParam = "message";
  static const String statusCode = "status";

  static const headers = {'Content-Type': 'application/json; charset=UTF-8'};
  static const pageSize = 10;
  static const timeout = 30;

  /// in seconds
  static const minimumFetchInterval = 24;

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
    UtilFunctions.appLog("TOKEN $token");
    final language = await sl<CacheService>().getLanguage();
    Map<String, String> headers = <String, String>{
      "Cache-Control": "no-cache",
      "Content-Type": contentType,
      "Authorization": "Bearer $token",
      "language": ?language,
      "Accept": contentType,
    };
    return headers;
  }

  static Future<Map<String, String>> getHeadersWithAuthNoContentType() async {
    final token = await sl<CacheService>().getSessionToken() ?? "";
    UtilFunctions.appLog("TOKEN $token");
    final language = await sl<CacheService>().getLanguage();
    Map<String, String> headers = <String, String>{
      "Cache-Control": "no-cache",
      "Authorization": "Bearer $token",
      "language": ?language,
    };
    return headers;
  }
}
