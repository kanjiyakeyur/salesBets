
import 'package:baseproject/core/utils/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class LocalNotification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          notificationCategories: <DarwinNotificationCategory>[
            DarwinNotificationCategory(
              'your_category_id',
              actions: <DarwinNotificationAction>[
                DarwinNotificationAction.plain(
                  'action_pause',
                  'Pause',
                  options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.foreground,
                  },
                ),
                DarwinNotificationAction.plain(
                  'action_stop',
                  'Stop',
                  options: <DarwinNotificationActionOption>{
                    DarwinNotificationActionOption.foreground,
                  },
                ),
              ],
            ),
          ],
        );

    InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        onActionCallEventHandler(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> sendSimpleNotification(
      int notificationId,
      String title,
      String description
      ) async {
    var hasNotificationPermission = await PermissionHandler()
        .checkPermissionAndRequest(Permission.notification);

    if (!hasNotificationPermission) {
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('action_pause', 'Pause', showsUserInterface: true),
            AndroidNotificationAction('action_stop', 'Stop', showsUserInterface: true),
          ],
          ticker: 'ticker',
        );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(presentAlert: true, categoryIdentifier: 'your_category_id');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      description,
      notificationDetails,
      payload: '-------------- item x',
    );
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // cancel one notification
  static Future<void> cancelOneNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(NotificationResponse response) {
    // Handle notification tap when the app is in the background
    onActionCallEventHandler(response);
  }

  static void onActionCallEventHandler(NotificationResponse response) {
    print("------------------------------------");
    print("notification action: ${response.actionId}");
    print('Notification tapped with payload: ${response.payload}');
  }
}
