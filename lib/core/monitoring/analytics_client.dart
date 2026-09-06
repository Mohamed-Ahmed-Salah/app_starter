/// Every analytics event the app can send, as a typed method. Providers
/// implement it; [AnalyticsFacade] fans one call out to all of them.
///
/// Add a feature's events here first (see the `analytics-tracking` skill), then
/// implement them in each provider and forward them in the facade.
abstract class AnalyticsClient {
  Future<void> identifyUser(String userId);

  Future<void> resetUser();

  Future<void> trackScreenView(
    String routeName,
    String action,
    Map<String, Object?>? args,
  );

  /// Fired once on first launch — represents both app download and onboarding start.
  Future<void> trackOnboardingStart({required String deviceId});
}
