import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_to/configs/app_configs.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/cores/managers/location_manager.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState()) {
    requestLocationPermission();
  }

  final appConfig = injector<AppConfig>();
  final userInfo = injector<UserInfo>();
  StreamSubscription<Position>? streamSubscriptionPosition;
  StreamSubscription<DatabaseEvent>? logoutListener;

  void changePageIndex({required int index}) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> requestLocationPermission() async {
    await LocationManager.requestPermissionLocation();
    if (injector<UserInfo>().type?.toLowerCase().compareTo("Customer".toLowerCase()) != 0) {
      streamSubscriptionPosition = LocationManager.listenToCurrentLocationChanges();
    }
    emit(state.copyWith(tempVal: state.tempVal > state.currentIndex ? state.currentIndex : state.tempVal));
  }

  Future<void> logout(void Function() backToLogin) async {
    Map<String, dynamic> preValue = {};
    final preSnapshot = await injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["logoutStatus"]}",
    ).get();
    if (preSnapshot.exists) {
      preValue = Map<String, dynamic>.from((preSnapshot.value ?? {}) as Map<dynamic, dynamic>);
    }

    final phoneNumber = injector<UserInfo>().phone ?? "";
    await injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["logout"]}",
    ).set({
      "id": injector<UserInfo>().id,
      "phoneNumber": phoneNumber,
      "time": UIHelper.getTimeStamp(),
    });

    logoutListener = injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["logoutStatus"]}",
    ).onValue.listen((event) async {
      final data = Map<String, dynamic>.from((event.snapshot.value ?? {}) as Map<dynamic, dynamic>);
      if (data["phoneNumber"]?.toString().compareTo(phoneNumber) == 0) {
        if (!(data["phoneNumber"]?.toString().compareTo(preValue["phoneNumber"]?.toString() ?? "") == 0
            && data["time"] == preValue["time"])) {
          if (data["successful"] == true) {
            if (userInfo.type?.toLowerCase().compareTo("Customer".toLowerCase()) != 0) {
              await injector<RealtimeDatabaseService>().ref.child(
                "${FirebaseConstants.databaseChildPath["availableDrivers"]}/${userInfo.id}",
              ).remove();
            }
            await injector<LocalStorageManager>().clearAll();
            await streamSubscriptionPosition?.cancel();
            Timer(const Duration(seconds: 2), () => backToLogin.call(),);
          } else {
            UIHelper.showErrorToast(data["error"]);
          }
          logoutListener?.cancel();
        }
      }
    });
  }
}
