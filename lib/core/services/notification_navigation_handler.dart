import '../../src/splash/presentation/view/splash_view.dart';
import '../config/enums.dart';
import '../config/models/notification_payload.dart';
import '../router.dart';
import '../utils/util_functions.dart';

class NotificationNavigationHandler {
  static final NotificationNavigationHandler _instance =
      NotificationNavigationHandler._();

  static NotificationNavigationHandler get to => _instance;

  NotificationNavigationHandler._();

  // Pending navigation for when app is starting
  NotificationPayload? _pendingNavigation;

  // Handle notification tap - routes to appropriate screen
  Future<void> handleNotificationTap(NotificationPayload payload) async {
    UtilFunctions.appLog("🔔 [NAV] handleNotificationTap() called");
    UtilFunctions.appLog("📱 [NAV] Payload type: ${payload.type.name}");
    UtilFunctions.appLog("📱 [NAV] Payload data: ${payload.data}");

    // Check if router is ready
    UtilFunctions.appLog("🔔 [NAV] Checking if router is ready...");
    final isReady = _isRouterReady();
    UtilFunctions.appLog("📱 [NAV] Router ready: $isReady");

    if (!isReady) {
      // Router not ready - store as pending
      UtilFunctions.appLog("⚠️ [NAV] Router NOT ready, storing as pending");
      _pendingNavigation = payload;
      return;
    }

    // Router is ready - navigate immediately
    UtilFunctions.appLog("✅ [NAV] Router ready, navigating...");
    await _navigate(payload);
  }

  // Process pending navigation (called after splash completes)
  Future<void> processPendingNavigation() async {
    UtilFunctions.appLog("🔔 [DEBUG] processPendingNavigation() called");
    UtilFunctions.appLog(
      "📱 [DEBUG] _pendingNavigation is null: ${_pendingNavigation == null}",
    );

    if (_pendingNavigation != null) {
      final payload = _pendingNavigation!;
      UtilFunctions.appLog(
        "✅ [DEBUG] Found pending navigation, type: ${payload.type.name}",
      );
      _pendingNavigation = null;
      UtilFunctions.appLog("🔔 [DEBUG] Calling _navigate()...");
      await _navigate(payload);
      UtilFunctions.appLog("✅ [DEBUG] Navigation completed");
    } else {
      UtilFunctions.appLog("ℹ️ [DEBUG] No Pending Navigation to process");
    }
  }

  void clearPendingNavigation() {
    UtilFunctions.appLog("🔔 [DEBUG] clearPendingNavigation() called");
    final hadPending = _pendingNavigation != null;
    _pendingNavigation = null;
    UtilFunctions.appLog(
      "📱 [DEBUG] Cleared pending navigation (had pending: $hadPending)",
    );
  }

  bool hasPendingNavigation() {
    final hasPending = _pendingNavigation != null;
    UtilFunctions.appLog("🔔 [DEBUG] hasPendingNavigation() = $hasPending");
    return hasPending;
  }

  // Core navigation logic
  Future<void> _navigate(NotificationPayload payload) async {
    UtilFunctions.appLog(
      "🔔 [DEBUG] _navigate() called with type: ${payload.type.name}",
    );

    try {
      switch (payload.type) {
        case NotificationType.notification:
          UtilFunctions.appLog("📱 [DEBUG] Navigating to notification...");
          break;
        //todo we have date
        //   case NotificationType.leavePendingApproval:
        //   final dynamic rawId = payload.data?['userId'];

        // final int? userId = rawIdHandler(rawId);
        // UtilFunctions.appLog(
        //"📱 [DEBUG] Navigating to LeaveHistory, userId: $userId",
        //);
        //_navigateToLeaveHistory(userId);
        //break;
        case NotificationType.general:
          UtilFunctions.appLog(
            "ℹ️ [DEBUG] General notification, no navigation needed",
          );
          break;
      }
      UtilFunctions.appLog("✅ [DEBUG] _navigate() completed successfully");
    } catch (e, stackTrace) {
      UtilFunctions.appLog("❌ [DEBUG] Error in _navigate(): $e");
      UtilFunctions.appLog("❌ [DEBUG] Stack trace: $stackTrace");
    }
  }

  bool _isRouterReady() {
    try {
      final config = router.routerDelegate.currentConfiguration;
      final currentPath = config.uri.path;

      UtilFunctions.appLog("📱 [NAV] Current path: $currentPath");

      // Router is ready if:
      // 1. Configuration exists
      // 2. We're not on splash screen (splash means still initializing)
      final isReady = config.isNotEmpty && currentPath != SplashView.path;

      UtilFunctions.appLog("📱 [NAV] Router ready result: $isReady");
      return isReady;
    } catch (e) {
      UtilFunctions.appLog("❌ [NAV] Error checking router: $e");
      return false;
    }
  }

  int? rawIdHandler(dynamic rawId) {
    return switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      _ => null, // null or unknown type
    };
  }
}
