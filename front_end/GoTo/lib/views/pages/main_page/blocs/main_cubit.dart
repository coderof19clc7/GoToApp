import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  // final ApiExecutor _apiExecutor = injector();

  void changePageIndex({required int index}) {
    emit(state.copyWith(currentIndex: index));
  }

  void logout(BuildContext context) {
    // fetchApi<BaseOutput>(() => _apiExecutor.logout(), showLoading: false);
    injector<LocalStorageManager>().clearAll();
    Navigator.pushNamedAndRemoveUntil(context, RouteConstants.signInRoute, (route) => false);
  }
}
