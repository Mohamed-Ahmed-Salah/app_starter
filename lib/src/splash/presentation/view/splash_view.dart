import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/models/notification_payload.dart';
import '../../../../core/constants/size_constants.dart';
import '../../../../core/res/media.dart';
import '../../../../core/router.dart';
import '../../../../core/services/notification_navigation_handler.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/util_functions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../../../force_update/presentation/view/force_update_view.dart';
import '../../../home/presentation/view/home_view.dart';
import '../../../onboarding/presentation/view/onboarding_view.dart';
import '../app/app_redirection_bloc/app_redirection_bloc.dart';

/// First screen. Shows the logo while [AppRedirectionBloc] (provided
/// app-wide, event already added) works out where to go, then `go`es there so
/// splash never stays on the stack.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String path = '/';
  static const String name = 'splash';

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
      body: BlocListener<AppRedirectionBloc, AppRedirectionState>(
        listener: (_, state) {
          state.whenOrNull(
            failed: (_) {
              UtilFunctions.showFailedToast(
                message: text?.couldntStartApp ?? "Couldn't start the app",
              );
            },
            successForceUpdate: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(ForceUpdateView.path);
            },
            successOnboarding: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(OnboardingView.path);
            },
            successNotLoggedIn: () {
              NotificationNavigationHandler.to.clearPendingNavigation();
              router.go(LoginView.path);
            },
            successLoggedIn: () {
              router.go(HomeView.path);
              _processPendingNavigation();
            },
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(SizeConstants.screenPadding),
            child: Image.asset(Media.appLogoImg),
          ),
        ),
      ),
    );
  }

  /// A signed-in user who opened the app from a notification lands on the
  /// screen the notification points at, once the router has settled.
  Future<void> _processPendingNavigation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (await _handleFcmLaunch()) return;
    if (await _handleLocalNotificationLaunch()) return;

    if (NotificationNavigationHandler.to.hasPendingNavigation()) {
      await NotificationNavigationHandler.to.processPendingNavigation();
    }
  }

  /// App launched from a push notification while terminated.
  Future<bool> _handleFcmLaunch() async {
    try {
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial == null || initial.data.isEmpty) return false;

      final payload = NotificationPayload.fromRemoteMessage(initial.data);
      await NotificationNavigationHandler.to.handleNotificationTap(payload);
      return true;
    } catch (e, stackTrace) {
      UtilFunctions.appLog("❌ [SPLASH] FCM launch check failed: $e\n$stackTrace");
      return false;
    }
  }

  /// App launched from a local notification while terminated.
  Future<bool> _handleLocalNotificationLaunch() async {
    try {
      final details = await NotificationService.to.flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      final json = details?.notificationResponse?.payload;
      if (details?.didNotificationLaunchApp != true ||
          json == null ||
          json.isEmpty) {
        return false;
      }

      final payload = NotificationPayload.fromJson(json);
      await NotificationNavigationHandler.to.handleNotificationTap(payload);
      return true;
    } catch (e, stackTrace) {
      UtilFunctions.appLog(
        "❌ [SPLASH] Local notification launch check failed: $e\n$stackTrace",
      );
      return false;
    }
  }
}
