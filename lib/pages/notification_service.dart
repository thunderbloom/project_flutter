import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Step 2. Create a NotificationService class

class NotificationService {
  // Singleton pattern, https://en.wikipedia.org/wiki/Singleton_pattern
  // 1.The _internal() construction is just a name often given to constructors
  // that are private to the class
  // 2.Use the factory keyword when implementing a constructor
  // that does not create a new instance of its class.
  NotificationService._internal();
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  // Configuration for platform-specific initialization settings.
  Future<void> init() async {
    // Specifies the default icon for notifications.
    // icon path: PROJECT_NAME\android\app\src\main\res\drawable\icon.png
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("icon");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Some configurations for platform-specific notification's details.
  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'ChannelId',
    'ChannelName',
    channelDescription: "Responsible for all local notifications",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );
  final NotificationDetails notificationDetails =
      const NotificationDetails(android: _androidNotificationDetails);

  // Now we need to call the show() method of FlutterLocalNotificationsPlugin.
  // Show() is responsible for showing the local notification.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails);
  }
}
