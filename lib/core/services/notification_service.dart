import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/enums.dart';
import '../config/models/notification_payload.dart';
import '../utils/util_functions.dart';
import 'cache_service.dart';
import 'injection_container.dart';
import 'notification_navigation_handler.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService to =
      NotificationService._privateConstructor();

  final CacheService _cacheService = sl<CacheService>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Hook for scheduled notifications: resolve the stored zone here once the
  /// `timezone` package is wired in.
  Future<void> _initTimeZone() async {
    await _cacheService.getTimeZone();
  }

  Future<void> initializeNotifications() async {
    // Initialize timezone database for scheduled notifications
    await _initTimeZone();
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (Darwin is used for both iOS and macOS)
    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // Combine Android and iOS initialization
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      // onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );
    await createNotificationChannel();
  }

  void _onNotificationTap(NotificationResponse response) async {
    UtilFunctions.appLog("🔔 [LOCAL] _onNotificationTap() called");
    UtilFunctions.appLog("📱 [LOCAL] Response ID: ${response.id}");
    UtilFunctions.appLog("📱 [LOCAL] Payload: ${response.payload}");

    final payloadJson = response.payload;
    if (payloadJson == null || payloadJson.isEmpty) {
      UtilFunctions.appLog("⚠️ [LOCAL] Payload is null or empty");
      return;
    }

    try {
      final payload = NotificationPayload.fromJson(payloadJson);
      UtilFunctions.appLog("✅ [LOCAL] Payload parsed: ${payload.type.name}");
      await NotificationNavigationHandler.to.handleNotificationTap(payload);
    } catch (e) {
      UtilFunctions.appLog('❌ [LOCAL] Error: $e');
    }
  }

  // Show a notification with given title and body
  Future<void> showNotification(
    int id,
    String title,
    String body, {
    NotificationPayload payload = const NotificationPayload(
      type: NotificationType.general,
    ),
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel', // Channel ID
          'High Importance Notifications', // Channel Name
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          icon: "ic_launcher",
          enableVibration: true,
        );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentSound: true,
          presentList: true,
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          sound: 'default',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload.toJson(),
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> createNotificationChannel() async {
    if (Platform.isAndroid) {
      const highImportanceChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidImplementation?.createNotificationChannel(
        highImportanceChannel,
      );

      UtilFunctions.appLog('✅ Notification channel created');
    }
  }

  Future<bool> doesChannelExist(String channelId) async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        final channels = await androidImplementation.getNotificationChannels();
        return channels?.any((channel) => channel.id == channelId) ?? false;
      }
    }
    return false;
  }

  /// Get list of all pending scheduled notifications
  ///
  /// Useful for debugging and showing user their active reminders
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
