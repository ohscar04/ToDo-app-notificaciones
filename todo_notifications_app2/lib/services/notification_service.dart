import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future init() async {

    await Permission.notification.request();

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
    settings =
    InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings,
    );
  }

  static Future showNotification({

    required String title,

    required String body,

  }) async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(

      'todo_channel',

      'Todo Notifications',

      channelDescription:
      'Canal de notificaciones',

      importance: Importance.max,

      priority: Priority.high,
    );

    const NotificationDetails
    notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(

      0,

      title,

      body,

      notificationDetails,
    );
  }
}