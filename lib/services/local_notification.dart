import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static void initialize(
      Function(NotificationResponse)? onDidReceiveNotificationResponse) {
    InitializationSettings initializationSettings = InitializationSettings(
        android: const AndroidInitializationSettings("@drawable/ic_launcher"),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ));
    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future showNotify({required RemoteMessage? message}) async {
    await _notificationsPlugin.show(
      DateTime.now().microsecond,
      message?.notification?.title,
      message?.notification?.body,
      NotificationDetails(
          android: AndroidNotificationDetails(
        "com.example.tech_initiator_task",
        "TechInitiatorTask",
        importance: Importance.max,
        priority: Priority.high,
      )),
    );
  }
}
