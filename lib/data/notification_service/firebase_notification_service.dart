import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../repository/auth_repo.dart';
import '../../core/utils/navigator_service.dart';
import 'notification_handler.dart';
import 'notification_model.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:onActionCallEventHandler,
      onDidReceiveNotificationResponse: onActionCallEventHandler
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');


      if (message.notification != null) {
        var payload = json.encode(message.data);
        _showNotification(message.notification!, payload: payload);
      }
    });

    // Handle message taps
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Handle navigation here
    });
    await registerDevice();
  }

  Future<void> registerDevice() async {
    try{
      var fcmToken = await getFCMToken();
      var deviceId = await getDeviceId();
      if(fcmToken != null && deviceId != null){
        // register device
      }
    } catch (_) {
      print("Crash in FCM token and device ID");
    }
  }

  Future<void> _showNotification(RemoteNotification notification, {String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: payload
    );
  }

  Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android ID
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Identifier for Vendor (IDFV)
    }
    return null;
  }

  Future<String?> getFCMToken() async {
    if (Platform.isIOS) {
      var tokenAPNST = await _waitForAPNSToken();
      // await _firebaseMessaging.getAPNSToken();
    }
    String? token = await _firebaseMessaging.getToken();
    // TODO: Save this token to your server or link it with the user account
    _firebaseMessaging.onTokenRefresh.listen((newValue) {
      //TODO: Handle token refresh on the server
    });
    print('FCM Token: $token');
    return token;
  }

  Future<void> _waitForAPNSToken() async {
    String? apnsToken;
    int attempts = 0;
    const maxAttempts = 10;

    while (apnsToken == null && attempts < maxAttempts) {
      try {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          // print('APNs token received: $apnsToken');
          break;
        }
      } catch (e) {
        // print('Waiting for APNs token... attempt ${attempts + 1}');
      }

      // print('apns attempt token : $attempts');
      attempts++;
      await Future.delayed(const Duration(seconds: 1));
    }

    if (apnsToken == null) {
      throw Exception('Failed to get APNs token after $maxAttempts attempts');
    }
  }

  static void onActionCallEventHandler(NotificationResponse response) {
    print("------------------------------------");
    print("notification action: ${response.actionId}");
    print('Notification tapped with payload: ${response.payload}');

    NotificationHandler.workflowOfNotification(response);



  }
}
