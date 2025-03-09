import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'local_notification.dart';

class NotificationHandler {
  static void initialize(BuildContext context) {
    LocalNotificationService.initialize(
      (id) async {
        print("onSelectNotification");
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      print("terminated");
      if (event?.notification != null) {
        print(event?.notification?.title);
        print(event?.notification?.body);
        _messageHandler(event);
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      print("forground");
      if (event.notification != null) {
        print(event.notification?.title);
        print(event.notification?.body);
        _messageHandler(event);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (event.notification != null) {
        print("backGround");
        print(event.notification?.title);
        print(event.notification?.body);
      }
    });
  }
}

Future<void> _messageHandler(RemoteMessage? message) async {
  RemoteMessage? data = message;
  await LocalNotificationService().showNotify(
    message: data,
  );
}
