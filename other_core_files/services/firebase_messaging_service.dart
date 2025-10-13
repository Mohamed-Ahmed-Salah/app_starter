import 'dart:io';

import 'package:attendance/core/services/firebase_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';
import 'package:attendance/core/utils/util_functions.dart';

@pragma('vm:entry-point')
class MyFirebaseMessagingService {
  static late final MyFirebaseMessagingService? _instance;

  static MyFirebaseMessagingService get to =>
      _instance ??= MyFirebaseMessagingService._();

  MyFirebaseMessagingService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<String?> getFCMToken() async {
    final String? fcmToken = await _messaging.getToken();
    return fcmToken;
  }

  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await initializeFirebaseApp();
    if (message.notification != null) {
      UtilFunctions.appLog('🔔 Notification Title: ${message.notification?.title}');
      UtilFunctions.appLog('💾 Notification Body: ${message.notification?.body}');
    }
    if (message.data.isNotEmpty) {
      UtilFunctions.appLog('💾❌ Data Payload: ${message.data}');
    }
  }

  // Start listening for foreground messages
  static void foregroundListening() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      UtilFunctions.appLog('🔔 Got a message whilst in the foreground!');
      UtilFunctions.appLog('💾 Message data: ${message.data}');

      if (message.notification != null) {
        UtilFunctions.appLog(
          'Message also contained a notification: ${message.notification?.toMap()}',
        );

        /// Show the notification when the app is in the foreground
        await NotificationService.to.showNotification(
          0, // Notification ID
          message.notification?.title ?? 'No Title',
          message.notification?.body ?? 'No Body',
        );
      }
    });
  }

  static Future<void> initNotifications() async {
    await NotificationService.to
        .initializeNotifications(); // Initialize notifications
    UtilFunctions.appLog("✅ NotificationService initialized with channel");
    final channelExists = await NotificationService.to.doesChannelExist(
      'high_importance_channel',
    );
    UtilFunctions.appLog("📱 Channel 'high_importance_channel' exists: $channelExists");
    UtilFunctions.appLog("🔄 Getting FCM token...");
    if (Platform.isIOS) {
      final apnsToken = await _messaging.getAPNSToken();
      if (apnsToken == null) {
        UtilFunctions.appLog('⚠️ No APNS token (simulator cannot receive push notifications)');
        return;
      }
    }
    final fcmToken = await getFCMToken();
    UtilFunctions.appLog("🔑 FCM Token: $fcmToken");

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    foregroundListening();

    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
          UtilFunctions.appLog("🔄 FCM token Refreshed! $fcmToken");

          ///todo make the get_employee_cubit
          // GetIt.instance.get<NotificationCubit>().updateNotification(fcmToken);
        })
        .onError((err) {
          UtilFunctions.appLog(
            "❌ Error when listening to FirebaseMessaging.instance.onTokenRefresh: $err",
          );// Error getting token.
        });
  }

  // Request user permission for notifications (iOS and Android 13+)
  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      UtilFunctions.appLog('User granted permission');
    } else {
      UtilFunctions.appLog('User declined or has not accepted permission');
    }
  }
}
