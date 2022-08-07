import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/models/infos/user_info.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  // final ApiExecutor _apiExecutor = injector();

  void changePageIndex({required int index}) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> logout(BuildContext context) async {
    injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["logout"]}",
    ).set({
      "phoneNumber": injector<UserInfo>().phone
    }).then((value) {
      injector<LocalStorageManager>().clearAll();
      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.signInRoute, (route) => false);
    });
  }
}
