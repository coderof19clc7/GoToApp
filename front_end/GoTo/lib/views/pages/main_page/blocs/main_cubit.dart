import 'dart:async';

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

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  AppConfig appConfig = injector<AppConfig>();
  StreamSubscription<Position>? streamSubscriptionPosition;

  void changePageIndex({required int index}) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> requestLocationPermission() async {
    await LocationManager.requestPermissionLocation();
    if (injector<UserInfo>().type?.toLowerCase().compareTo("Customer".toLowerCase()) != 0) {
      streamSubscriptionPosition = LocationManager.listenToCurrentLocationChanges();
    }
  }

  Future<void> logout(void Function() backToLogin) async {
    injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["logout"]}",
    ).set({
      "phoneNumber": injector<UserInfo>().phone
    }).then((value) async {
      injector<LocalStorageManager>().clearAll();
      await streamSubscriptionPosition?.cancel();
      backToLogin.call();
    });
  }
}
