import './analytics_client.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseAnalyticsClient implements AnalyticsClient {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Future<void> identifyUser(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  @override
  Future<void> resetUser() async {
    await _analytics.setUserId(id: null);
  }

  @override
  Future<void> trackScreenView(
    String routeName,
    String action,
    Map<String, Object?>? args,
  ) async {
    await _analytics.logScreenView(
      screenName: 'screen_view',
      parameters: {
        ..._sanitizeParams(args),
        // path params first, so they can't clobber name/action
        'name': routeName,
        'action': action,
      },
    );
  }

  @override
  Future<void> trackOnboardingStart({required String deviceId}) async {
    await _analytics.logEvent(
      name: 'onboarding_start',
      parameters: {'device_id': deviceId},
    );
  }

  // Firebase only accepts String or num as parameter values.
  // Nulls, bools, maps and lists are rejected — a debug-mode assert,
  // silently dropped in release. So coerce here.
  Map<String, Object> _sanitizeParams(Map<String, Object?>? args) {
    if (args == null) return const {};
    final out = <String, Object>{};
    args.forEach((key, value) {
      if (value == null) return; // drop nulls
      out[key] = value is num
          ? value
          : value.toString(); // String/num pass; rest stringified
    });
    return out;
  }
}
