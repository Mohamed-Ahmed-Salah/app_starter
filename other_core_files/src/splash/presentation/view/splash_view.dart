import 'package:attendance/core/config/models/notification_payload.dart';
import 'package:attendance/core/constants/size_constants.dart';
import 'package:attendance/core/res/media.dart';
import 'package:attendance/core/services/notification_navigation_handler.dart';
import 'package:attendance/core/services/notification_service.dart';
import 'package:attendance/core/services/router.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:attendance/l10n/app_localizations.dart';
import 'package:attendance/src/auth/presentation/view/login_view.dart';
import 'package:attendance/src/force_update/presentation/view/force_update_view.dart';
import 'package:attendance/src/home/presentation/view/home_view.dart';
import 'package:attendance/src/onboarding/presentation/view/onboarding_view.dart';
import 'package:attendance/src/splash/presentation/app/app_redirection_bloc/app_redirection_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashView extends StatelessWidget {
  static const String path = "/splash";
  static const String name = "/splash";

  const SplashView({super.key});

  void _processPendingNavigation() async {
    UtilFunctions.appLog("🔔 [SPLASH] _processPendingNavigation() START");

    // Small delay to ensure router navigation has settled
    await Future.delayed(const Duration(milliseconds: 300));

    // Priority 1: Check for FCM notification launch (remote notifications)
    final bool fcmHandled = await _checkFCMNotificationLaunch();
    if (fcmHandled) {
      UtilFunctions.appLog("✅ [SPLASH] FCM notification handled, done");
      return;
    }

    // Priority 2: Check for local notification launch
    final bool localHandled = await _checkLocalNotificationLaunch();
    if (localHandled) {
      UtilFunctions.appLog("✅ [SPLASH] Local notification handled, done");
      return;
    }

    // Priority 3: Check for any stored pending navigation (edge cases)
    if (NotificationNavigationHandler.to.hasPendingNavigation()) {
      UtilFunctions.appLog("📱 [SPLASH] Processing stored pending navigation");
      NotificationNavigationHandler.to.processPendingNavigation();
      return;
    }

    UtilFunctions.appLog("ℹ️ [SPLASH] No notification launch detected");
  }

  /// Check if app was launched from FCM notification (terminated state)
  Future<bool> _checkFCMNotificationLaunch() async {
    UtilFunctions.appLog("🔔 [SPLASH] Checking FCM initial message...");

    try {
      final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage == null) {
        UtilFunctions.appLog("ℹ️ [SPLASH] No FCM initial message");
        return false;
      }

      UtilFunctions.appLog("✅ [SPLASH] FCM initial message found!");
      UtilFunctions.appLog("📱 [SPLASH] Title: ${initialMessage.notification?.title}");
      UtilFunctions.appLog("📱 [SPLASH] Data: ${initialMessage.data}");

      if (initialMessage.data.isEmpty) {
        UtilFunctions.appLog("⚠️ [SPLASH] FCM data is empty, skipping");
        return false;
      }

      // Create payload and navigate
      final payload = NotificationPayload.fromRemoteMessage(initialMessage.data);
      UtilFunctions.appLog("📱 [SPLASH] Payload type: ${payload.type.name}");

      // At this point, router is ready, navigate directly
      await NotificationNavigationHandler.to.handleNotificationTap(payload);

      return true;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("❌ [SPLASH] Error checking FCM launch: $e");
      UtilFunctions.appLog("❌ [SPLASH] Stack trace: $stackTrace");
      return false;
    }
  }

  /// Check if app was launched from local notification (terminated state)
  Future<bool> _checkLocalNotificationLaunch() async {
    UtilFunctions.appLog("🔔 [SPLASH] Checking local notification launch...");

    try {
      final NotificationAppLaunchDetails? launchDetails =
      await NotificationService.to.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

      if (launchDetails == null) {
        UtilFunctions.appLog("ℹ️ [SPLASH] No launch details");
        return false;
      }

      UtilFunctions.appLog("📱 [SPLASH] Launch details found:");
      UtilFunctions.appLog("   - didNotificationLaunchApp: ${launchDetails.didNotificationLaunchApp}");

      if (!launchDetails.didNotificationLaunchApp) {
        UtilFunctions.appLog("ℹ️ [SPLASH] App not launched from notification");
        return false;
      }

      final response = launchDetails.notificationResponse;
      if (response == null || response.payload == null || response.payload!.isEmpty) {
        UtilFunctions.appLog("⚠️ [SPLASH] No payload in notification response");
        return false;
      }

      UtilFunctions.appLog("✅ [SPLASH] Local notification launch detected!");
      UtilFunctions.appLog("📱 [SPLASH] Notification ID: ${response.id}");
      UtilFunctions.appLog("📱 [SPLASH] Payload: ${response.payload}");

      // Create payload and navigate
      final payload = NotificationPayload.fromJson(response.payload!);
      UtilFunctions.appLog("📱 [SPLASH] Payload type: ${payload.type.name}");

      // At this point, router is ready, navigate directly
      await NotificationNavigationHandler.to.handleNotificationTap(payload);

      return true;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("❌ [SPLASH] Error checking local launch: $e");
      UtilFunctions.appLog("❌ [SPLASH] Stack trace: $stackTrace");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AppRedirectionBloc, AppRedirectionState>(
        listener: (BuildContext _, state) {
          state.whenOrNull(
            failed: (message) {
              UtilFunctions.showSnackBar(
                message: "${AppLocalizations.of(context)?.couldntStartApp}",
              );
            },
            successForceUpdate: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(ForceUpdateView.name);
            },
            successLoggedIn: () {
              router.go(HomeView.name);
              // Process any pending notification navigation
              _processPendingNavigation();
            },
            successNotLoggedIn: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(LoginView.name);
            },
            successOnboarding: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(OnBoardingView.name);
            },
          );
        },
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    (SizeConstants.baseHorizontalPadding +
                            SizeConstants.padding)
                        .w,
              ),
              child: Image.asset(Media.logo),
            ),
          ),
        ),
      ),
    );
  }
}
