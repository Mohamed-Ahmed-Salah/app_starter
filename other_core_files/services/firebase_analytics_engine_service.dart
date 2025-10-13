import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

  void logError(dynamic error, StackTrace stack, {bool fatal = false}) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
  }
}
