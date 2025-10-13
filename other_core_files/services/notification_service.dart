import 'dart:io';

import 'package:attendance/core/utils/util_functions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService to =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

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
      initializationSettings,
      // onDidReceiveNotificationResponse: (NotificationResponse response) async {
      //   /// todo Handle when a user taps the notification (foreground/background)
      // },
      // onDidReceiveBackgroundNotificationResponse: (response) {
      //   /// todo Handle when a user taps the notification (foreground/background)
      // },
    );
    await createNotificationChannel();
  }

  // Show a notification with given title and body
  Future<void> showNotification(int id, String title, String body) async {
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
      id, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> createNotificationChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // Must match your AndroidManifest.xml
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      UtilFunctions.appLog('✅ Notification channel created: high_importance_channel');
    }
  }

  Future<bool> doesChannelExist(String channelId) async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final channels = await androidImplementation.getNotificationChannels();
        return channels?.any((channel) => channel.id == channelId) ?? false;
      }
    }
    return false;
  }
}
