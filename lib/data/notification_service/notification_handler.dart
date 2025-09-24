import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_model.dart';

class NotificationHandler {
  static Future<void> workflowOfNotification(
    NotificationResponse response,
  ) async {
    // Handle the workflow of notification

    if (response.actionId == "action_ID") {
      // Handle pause action
    } else {
      var payload = json.decode(response.payload ?? '{}');
      await handleNotificationFromPayload(payload);
    }
  }

  static Future<void> handleNotificationFromPayload(
    Map<String, dynamic> payload,
  ) async {
    var notificationData = NotificationData.fromJson(payload);

    var routeName = notificationData.initialRoute;

  }

}
