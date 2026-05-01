import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1565C0),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();
    Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await notifications.initialize(settings);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(MyApp());
}
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'task_channel',
    'Tasks',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await notifications.show(
    0,
    title,
    body,
    details,
  );
}