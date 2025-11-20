import 'dart:convert';

import 'package:attendance/core/config/enums.dart';

class NotificationPayload {
  final NotificationType type;
  final Map<String, dynamic>? data;

  const NotificationPayload({required this.type, this.data});

  // Serialize for local notifications
  String toJson() => jsonEncode({'type': type.name, 'data': data});

  // Deserialize from notification response
  factory NotificationPayload.fromJson(String json) {
    final map = jsonDecode(json);
    return NotificationPayload(
      type: NotificationType.fromString(map['type']),
      data: map['data'],
    );
  }

  // Parse from FCM RemoteMessage.data
  factory NotificationPayload.fromRemoteMessage(Map<String, dynamic> data) {
    return NotificationPayload(
      type: NotificationType.fromString(data['type']),
      data: data,
    );
  }
}
