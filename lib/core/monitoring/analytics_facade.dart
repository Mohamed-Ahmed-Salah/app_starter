import './analytics_client.dart';

// https://refactoring.guru/design-patterns/facade
class AnalyticsFacade implements AnalyticsClient {
  const AnalyticsFacade(this.clients);

  final List<AnalyticsClient> clients;

  @override
  Future<void> identifyUser(String userId) =>
      _dispatch((c) => c.identifyUser(userId));

  @override
  Future<void> resetUser() => _dispatch((c) => c.resetUser());

  @override
  Future<void> trackScreenView(
    String routeName,
    String action,
    Map<String, Object?>? args,
  ) async {
    // * Only 'push' and 'replace' actions count as screen views (but not 'pop')
    if (action != 'pop') {
      await _dispatch((c) => c.trackScreenView(routeName, action, args));
    }
  }

  @override
  Future<void> trackOnboardingStart({required String deviceId}) =>
      _dispatch((c) => c.trackOnboardingStart(deviceId: deviceId));

  Future<void> _dispatch(
    Future<void> Function(AnalyticsClient client) work,
  ) async {
    for (var client in clients) {
      await work(client);
    }
  }
}
