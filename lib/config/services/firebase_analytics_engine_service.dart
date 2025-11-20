import 'package:app_starter/config/errors/exceptions.dart';
import 'package:app_starter/config/utils/util_functions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticsEngineService {
  // Singleton instance
  static final FirebaseAnalyticsEngineService _instance =
      FirebaseAnalyticsEngineService._internal();

  static FirebaseAnalyticsEngineService get to => _instance;

  // Private constructor
  FirebaseAnalyticsEngineService._internal();

  // Firebase SDKs
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> init() async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  void logEvent(String name, {Map<String, Object>? parameters}) {
    _analytics.logEvent(name: name, parameters: parameters);
  }

  // void logError(dynamic error, StackTrace stack, {bool fatal = false}) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  // }

  /// Log exception to Firebase Crashlytics with context
  void logError(
    dynamic exception,
    StackTrace stackTrace, {
    bool fatal = false,
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    UtilFunctions.appLog("tracing error: ${stackTrace.toString()}");
    // Add custom keys for better debugging
    if (context != null) {
      FirebaseCrashlytics.instance.setCustomKey('error_context', context);
    }

    // Add exception type
    FirebaseCrashlytics.instance.setCustomKey(
      'exception_type',
      exception.runtimeType.toString(),
    );

    // Add any additional data
    if (additionalData != null) {
      additionalData.forEach((key, value) {
        FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
      });
    }

    // Add specific details based on exception type
    if (exception is ServerException) {
      FirebaseCrashlytics.instance.setCustomKey(
        'status_code',
        exception.statusCode,
      );
      FirebaseCrashlytics.instance.setCustomKey(
        'error_message',
        exception.message,
      );
    } else if (exception is GeneralException) {
      FirebaseCrashlytics.instance.setCustomKey(
        'status_code',
        exception.statusCode,
      );
      FirebaseCrashlytics.instance.setCustomKey(
        'errors',
        "${exception.message} ${exception.errors.join(', ')}",
      );
    } else if (exception is DioException) {
      FirebaseCrashlytics.instance.setCustomKey(
        'dio_type',
        exception.type.toString(),
      );
      if (exception.response != null) {
        FirebaseCrashlytics.instance.setCustomKey(
          'status_code',
          exception.response!.statusCode ?? 0,
        );
        FirebaseCrashlytics.instance.setCustomKey(
          'response_data',
          exception.response!.data.toString(),
        );
      }
    }

    // Record the error with full stack trace
    FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      reason: context,
      fatal: false,
    );
  }
}
