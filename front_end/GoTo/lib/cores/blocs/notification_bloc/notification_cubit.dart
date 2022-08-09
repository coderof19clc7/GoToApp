import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/cores/managers/awesome_notification_manager.dart';

part 'notification_state.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.toString()}");
  }
  AwesomeNotificationsManager.createNotification(message);
}

class NotificationCubit extends Cubit<NotificationState> {
  final _firebaseMessaging = FirebaseMessaging.instance;

  NotificationCubit() : super(const NotificationState()) {
    getDataNotification();
  }

  void getDataNotification() async {
    await askForPermission();

    print(await _firebaseMessaging.getToken());

    //get any messages which caused the application to open from a terminated state.
    _firebaseMessaging.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        print('App opened from terminated state by a notification with the information: ');
        _emitState(initialMessage);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      print('message data: ' + message.data.toString());
      //notify to screen cubit.
      _emitState(message);
    },);

    //handle any interaction when the app is in the background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //get the message which caused the application to open from the background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('App opened from background by a notification with the information: ');
      _emitState(message);
    });

    // With this token you can test it easily on your phone
    // final token = await _firebaseMessaging.getToken();
    // String tokenFinal = token ?? '';
    // print('tokenFinal firebase $tokenFinal');
    // emit(state.copyWith(tokenFirebase: tokenFinal));
  }

  void onAppOpenedByAwesomeNotification(ReceivedAction receivedAction) {
    final remoteMessage = RemoteMessage(data: {"content": jsonEncode(receivedAction.toMap())});
    _emitState(remoteMessage);
  }

  void _emitState(RemoteMessage remoteMessage) {
    final content = jsonDecode(remoteMessage.data["content"]);
    emit(state.copyWith(
      title: content?["title"],
      body: content?["body"],
      message: remoteMessage,
      tapped: true,
    ));
  }

  askForPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
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
