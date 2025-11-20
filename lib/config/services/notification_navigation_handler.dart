

import 'package:app_starter/config/enums.dart';
import 'package:app_starter/config/models/notification_payload.dart';
import 'package:app_starter/config/utils/util_functions.dart';

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
        case NotificationType.checkoutReminder:
          UtilFunctions.appLog("📱 [DEBUG] Navigating to CheckInOut...");
          _navigateToCheckInOut();
          break;

        case NotificationType.leaveApproved:
        case NotificationType.leavePending:
          // final userId = int.tryParse(
          //   (payload.data?['userId'] ?? "").toString(),
          // );
          final dynamic rawId = payload.data?['userId'];

          final int? userId = rawIdHandler(rawId);
          UtilFunctions.appLog(
            "📱 [DEBUG] Navigating to LeaveHistory, userId: $userId",
          );
          _navigateToLeaveHistory(userId);
          break;

        case NotificationType.attendanceAlert:
          final dynamic rawId = payload.data?['employeeId'];

          final int? employeeId = rawIdHandler(rawId);

          UtilFunctions.appLog(
            "📱 [DEBUG] Navigating to AttendanceHistory, employeeId: $employeeId",
          );
          _navigateToAttendanceHistory(employeeId);
          break;

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
      // final config = router.routerDelegate.currentConfiguration;
      // final currentPath = config.uri.path;
      //
      // UtilFunctions.appLog("📱 [NAV] Current path: $currentPath");
      //
      // // Router is ready if:
      // // 1. Configuration exists
      // // 2. We're not on splash screen (splash means still initializing)
      // final isReady = config.isNotEmpty && currentPath != SplashView.path;
      //
      // UtilFunctions.appLog("📱 [NAV] Router ready result: $isReady");
      // return isReady;
      return true;
    } catch (e) {
      UtilFunctions.appLog("❌ [NAV] Error checking router: $e");
      return false;
    }
  }

  void _navigateToCheckInOut() async {
    // UtilFunctions.appLog("🔔 [DEBUG] _navigateToCheckInOut() START");
    // try {
    //   final cameras = await availableCameras();
    //   UtilFunctions.appLog("📱 [DEBUG] Available cameras: ${cameras.length}");
    //   UtilFunctions.appLog("🔔 [DEBUG] Calling router.push()...");
    //   router.push(CheckInOutView.name, extra: cameras);
    //   UtilFunctions.appLog("✅ [DEBUG] router.push() completed");
    // } catch (e, stackTrace) {
    //   UtilFunctions.appLog("❌ [DEBUG] Error in _navigateToCheckInOut(): $e");
    //   UtilFunctions.appLog("❌ [DEBUG] Stack trace: $stackTrace");
    // }
  }

  void _navigateToLeaveHistory(int? userId) {
    // UtilFunctions.appLog(
    //   "🔔 [DEBUG] _navigateToLeaveHistory() with userId: $userId",
    // );
    // try {
    //   if (userId != null) {
    //     router.push(UserLeaveHistoryView.path, extra: userId);
    //     UtilFunctions.appLog("✅ [DEBUG] Navigation to leave history completed");
    //   } else {
    //     UtilFunctions.appLog("⚠️ [DEBUG] userId is null, skipping navigation");
    //   }
    // } catch (e, stackTrace) {
    //   UtilFunctions.appLog("❌ [DEBUG] Error in _navigateToLeaveHistory(): $e");
    //   UtilFunctions.appLog("❌ [DEBUG] Stack trace: $stackTrace");
    // }
  }

  void _navigateToAttendanceHistory(int? employeeId) {
    // UtilFunctions.appLog(
    //   "🔔 [DEBUG] _navigateToAttendanceHistory() with employeeId: $employeeId",
    // );
    // try {
    //   if (employeeId != null) {
    //     router.push(AttendanceHistoryView.name, extra: employeeId);
    //     UtilFunctions.appLog(
    //       "✅ [DEBUG] Navigation to attendance history completed",
    //     );
    //   } else {
    //     UtilFunctions.appLog(
    //       "⚠️ [DEBUG] employeeId is null, skipping navigation",
    //     );
    //   }
    // } catch (e, stackTrace) {
    //   UtilFunctions.appLog(
    //     "❌ [DEBUG] Error in _navigateToAttendanceHistory(): $e",
    //   );
    //   UtilFunctions.appLog("❌ [DEBUG] Stack trace: $stackTrace");
    // }
  }

  int? rawIdHandler(dynamic rawId) {
    return switch (rawId) {
      int value => value,
      String value => int.tryParse(value),
      _ => null, // null or unknown type
    };
  }
}
