import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/firebase_configs/fcm_service.dart';
import 'package:go_to/configs/firebase_configs/firebase_options.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/cores/managers/awesome_notification_manager.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/cores/managers/location_manager.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/infos/user_info.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  //init firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FirebaseCrashlytics.instance.setUserIdentifier("7887");
  // FirebaseCrashlytics.instance.crash();

  //app config
  await LocalStorageManager.init();
  injector.registerSingleton<LocalStorageManager>(LocalStorageManager.getInstance());
  injector.registerSingleton<AppConfig>(await AppConfig.getInstance());

  injector.registerSingleton<UserInfo>(UserInfo.createInstance());
  
  //get realtime database reference
  injector.registerSingleton<RealtimeDatabaseService>(RealtimeDatabaseService.instance);

  //start fcm service
  // await FcmService.instance.startService();

  //init awesome notifications
  await AwesomeNotificationsManager.initialize();

  //network
  injector.registerSingleton<NetworkManager>(NetworkManager.getInstance());
  // injector.registerSingleton<RemoteConfigHelper>(RemoteConfigHelper.init());
  // injector.registerSingleton<ApiExecutor>(ApiExecutor());

  //location
  injector.registerSingleton<LocationManager>(LocationManager.getInstance());
}