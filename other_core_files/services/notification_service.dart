import 'dart:io';

import 'package:attendance/core/config/enums.dart';
import 'package:attendance/core/config/models/notification_payload.dart';
import 'package:attendance/core/services/notification_navigation_handler.dart';
import 'package:attendance/core/utils/util_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService to =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _initTimeZone() async {
    // Initialize timezone database for scheduled notifications
    tz_data.initializeTimeZones();
    final String localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    UtilFunctions.appLog("Received LocalTimeZine: $localTimeZone");
    tz.setLocalLocation(tz.getLocation(localTimeZone));
  }

  Future<void> initializeNotifications() async {
    // Initialize timezone database for scheduled notifications
    _initTimeZone();
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
      onDidReceiveNotificationResponse: _onNotificationTap,
      // onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );
    await createNotificationChannel();
  }

  // void _onNotificationTap(NotificationResponse response) async {
  //   UtilFunctions.appLog("🔔 [DEBUG] _onNotificationTap() called");
  //   UtilFunctions.appLog("📱 [DEBUG] Response ID: ${response.id}");
  //   UtilFunctions.appLog("📱 [DEBUG] Payload: ${response.payload}");
  //   UtilFunctions.appLog("📱 [DEBUG] Action ID: ${response.actionId}");
  //   UtilFunctions.appLog("📱 [DEBUG] Input: ${response.input}");
  //
  //   final payloadJson = response.payload;
  //   if (payloadJson == null || payloadJson.isEmpty) {
  //     UtilFunctions.appLog("⚠️ [DEBUG] Payload is null or empty, skipping");
  //     return;
  //   }
  //
  //   try {
  //     UtilFunctions.appLog("🔔 [DEBUG] Parsing payload JSON...");
  //     final payload = NotificationPayload.fromJson(payloadJson);
  //     UtilFunctions.appLog(
  //       "✅ [DEBUG] Payload parsed, type: ${payload.type.name}",
  //     );
  //     UtilFunctions.appLog("🔔 [DEBUG] Calling handleNotificationTap()...");
  //     await NotificationNavigationHandler.to.handleNotificationTap(payload);
  //     UtilFunctions.appLog("✅ [DEBUG] handleNotificationTap() completed");
  //   } catch (e, stackTrace) {
  //     UtilFunctions.appLog('❌ [DEBUG] Error in _onNotificationTap: $e');
  //     UtilFunctions.appLog('❌ [DEBUG] Stack trace: $stackTrace');
  //   }
  // }
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
      payload: payload.toJson(),
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
      // Existing channel
      const highImportanceChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      // NEW: Checkout reminders channel
      const checkoutChannel = AndroidNotificationChannel(
        'checkout_reminders',
        'Checkout Reminders',
        description: 'Notifications for checkout time reminders',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      // NEW: Test notifications channel
      const testChannel = AndroidNotificationChannel(
        'test_notifications',
        'Test Notifications',
        description: 'Test notifications for debugging',
        importance: Importance.high,
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
      await androidImplementation?.createNotificationChannel(checkoutChannel);
      await androidImplementation?.createNotificationChannel(testChannel);

      UtilFunctions.appLog('✅ Notification channels created');
      // const AndroidNotificationChannel channel = AndroidNotificationChannel(
      //   'high_importance_channel', // Must match your AndroidManifest.xml
      //   'High Importance Notifications',
      //   description: 'This channel is used for important notifications.',
      //   importance: Importance.max,
      //   playSound: true,
      //   enableVibration: true,
      //   showBadge: true,
      // );
      //
      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //       AndroidFlutterLocalNotificationsPlugin
      //     >()
      //     ?.createNotificationChannel(channel);
      //
      // UtilFunctions.appLog(
      //   '✅ Notification channel created: high_importance_channel',
      // );
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

  /// Schedule notification for estimated checkout time
  ///
  /// Estimated checkout = checkIn + working hours
  /// Notification scheduled = estimated checkout + grace period
  ///
  /// Parameters:
  /// - [checkInDateTime]: When the user checked in
  /// - [workingHoursStart]: Start hour of working day (e.g., 9 for 9:00 AM)
  /// - [workingHoursEnd]: End hour of working day (e.g., 17 for 5:00 PM)
  /// - [lateGraceMinutes]: Minutes after checkout to trigger notification (e.g., 15 minutes)
  /// - [title]: Notification title
  /// - [body]: Notification body text
  /// - [notificationId]: Unique ID for this notification
  Future<void> scheduleCheckoutReminder({
    required DateTime checkInDateTime,
    required double scheduledWorkHours,
    // required TimeOfDay workingHoursStart, // e.g., TimeOfDay(8, 30)
    // required TimeOfDay workingHoursEnd,
    required int lateGraceMinutes,
    required String title,
    required String body,
    required int notificationId,
  }) async {
    final workingDurationMinutes = (scheduledWorkHours * 60).toInt();
    // calculateDuration(
    //   start: workingHoursStart,
    //   end: workingHoursEnd,
    // );
    // Calculate estimated checkout time (checkIn + working hours)
    final estimatedCheckout = checkInDateTime.add(
      Duration(minutes: workingDurationMinutes),
    );

    // Schedule notification for grace period AFTER estimated checkout
    // final notificationTime = estimatedCheckout.add(
    //   Duration(minutes: lateGraceMinutes),
    // );

    // Convert to timezone-aware datetime
    final scheduledDate = tz.TZDateTime.from(estimatedCheckout, tz.local);

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'checkout_reminders', // channel ID
      'Checkout Reminders', // channel name
      channelDescription: 'Notifications for checkout time reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_launcher',
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    final payload = NotificationPayload(
      type: NotificationType.checkoutReminder,
    );

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload.toJson(),
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );

    UtilFunctions.appLog(
      '✅ Scheduled checkout reminder for: $scheduledDate (ID: $notificationId)\n'
      '   Check-in: $checkInDateTime\n'
      '   Estimated checkout: $estimatedCheckout',
    );
  }

  int calculateDuration({required TimeOfDay start, required TimeOfDay end}) {
    // Convert start and end times to minutes since midnight
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;

    // Calculate the difference
    int durationMinutes = endMinutes - startMinutes;

    // Optional: handle negative durations if end is before start
    if (durationMinutes < 0) {
      durationMinutes += 24 * 60; // assume end is next day
    }

    return durationMinutes;
  }

  /// Schedule a test notification 1 minute from current time
  ///
  /// Useful for testing the notification system
  ///
  /// Parameters:
  /// - [title]: Notification title
  /// - [body]: Notification body text
  /// - [notificationId]: Unique ID for this notification (default: 999)
  Future<void> scheduleTestNotification({
    required String title,
    required String body,
    int notificationId = 999,
    NotificationType type = NotificationType.checkoutReminder,
  }) async {
    // Calculate time 1 minute from now
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(minutes: 1));

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'test_notifications', // channel ID
      'Test Notifications', // channel name
      channelDescription: 'Test notifications for debugging',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: 'ic_launcher',
    );

    // iOS notification details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = NotificationPayload(type: type, data: {"userId": 3});
    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload.toJson(),
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
    );

    UtilFunctions.appLog(
      '✅ Test notification scheduled for: $scheduledDate (1 minute from now)',
    );
  }

  /// Get list of all pending scheduled notifications
  ///
  /// Useful for debugging and showing user their active reminders
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
