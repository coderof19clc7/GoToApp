import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/keys/notification_keys.dart';
import 'package:go_to/configs/constants/keys/storage_keys.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';

class AwesomeNotificationsManager {
  static final _localStorageManager = injector<LocalStorageManager>();

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      //using the default app icon for notification logo
      null,
      [
        NotificationChannel(
            channelGroupKey: NotificationKeys.basicChannelGroupKey,
            channelKey: NotificationKeys.basicChannelKey,
            channelName: NotificationKeys.basicChannelNameKey,
            channelDescription: 'Notification channel for basic tests',
            defaultColor: ColorConstants.defaultNotificationColor,
            ledColor: ColorConstants.baseWhite,
            playSound: true,
            channelShowBadge: true,
            //importance to show a notification at head of device
            importance: NotificationImportance.High)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: NotificationKeys.basicChannelGroupKey,
            channelGroupName: NotificationKeys.basicGroupNameKey)
      ],
      debug: true,
    );
  }

  static Future<bool> checkNotificationPermission() async {
    return await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      while (!isAllowed) {
        isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: NotificationKeys.basicChannelKey,
        );
      }
      _saveNotificationPermissionState(true);
      return true;
    });
  }

  static Future<void> createNotification(RemoteMessage message) async {
    final bool isAllowed = await checkNotificationPermission();
    if (isAllowed) {
      print('OK');
      await AwesomeNotifications().createNotificationFromJsonData(message.data);
    }
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    if (receivedAction.channelKey == NotificationKeys.basicChannelKey && Platform.isIOS) {
      AwesomeNotifications().getGlobalBadgeCounter().then((badgeNumber) {
        AwesomeNotifications().setGlobalBadgeCounter(badgeNumber - 1);
      });
    }
    print('User clicked on a notification');
  }

  static Future<void> _saveNotificationPermissionState(bool permission) async {
    await _localStorageManager.setBool(LocalStorageKeys.allowNotificationKey, permission);
  }

// static Future<bool> redirectToPermissionsPage() async {
//   await AwesomeNotifications().showNotificationConfigPage();
//   return await AwesomeNotifications().isNotificationAllowed();
// }
//
// static Future<void> redirectToBasicChannelPage() async {
//   await AwesomeNotifications().showNotificationConfigPage(channelKey: 'basic_channel');
// }
//
// static Future<void> redirectToAlarmPage() async {
//   await AwesomeNotifications().showAlarmPage();
// }
//
// static Future<void> redirectToScheduledChannelsPage() async {
//   await AwesomeNotifications().showNotificationConfigPage(channelKey: 'scheduled');
// }
//
// static Future<void> redirectToOverrideDndsPage() async {
//   await AwesomeNotifications().showGlobalDndOverridePage();
// }
}