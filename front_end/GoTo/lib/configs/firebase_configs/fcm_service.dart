import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_to/cores/managers/awesome_notification_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.toString()}");
  }
  AwesomeNotificationsManager.createNotification(message);
}

class FcmService {
  FcmService.init();

  static FcmService get instance => FcmService.init();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future startService() async {
    await askForPermission();

    print(await messaging.getToken());

    //get any messages which caused the application to open from a terminated state.
    messaging.getInitialMessage().then((initialMessage) {
      if (kDebugMode) {
        if (initialMessage != null) {
          print('App opened from terminated state by a notification with the information: ');
          if (initialMessage.notification != null ) {
            print("Title:" '${initialMessage.notification?.title}');
            print("Body:" '${initialMessage.notification?.body}');
            // handleOnNotificationTapped(initialMessage);
          }
        }
      }
    });

    //listen to messages whilst your application is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print('Message data: ${message.notification}');
        print('Message also contained a notification with the information:');
        print("Title:" '${message.notification?.title}');
        print("Body:" '${message.notification?.body}');
        final type = jsonDecode(message.data["content"]);
        print(type["phoneCLient"]);
      }
      AwesomeNotificationsManager.createNotification(message);
    });

    //handle any interaction when the app is in the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //get the message which caused the application to open from the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('App opened from background by a notification with the information: ');
        if (message.notification != null) {
          print("Title:" '${message.notification?.title}');
          print("Body:" '${message.notification?.body}');
          // handleOnNotificationTapped(message);
        }
      }
    });
  }

  askForPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          print('authorized');
          break;
        case AuthorizationStatus.denied:
          print('denied');
          break;
        case AuthorizationStatus.notDetermined:
          print('notDetermined');
          break;
        case AuthorizationStatus.provisional:
          print('provisional');
      }
    }
  }
}
