import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/keys/storage_keys.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/auth_bloc/auth_cubit.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/models/common/user_info.dart';

part 'sign_in_state.dart';

class SignInCubit extends AuthCubit<SignInState> {
  SignInCubit() : super(
    authState: const SignInState(), authAction: StringConstants.signIn,
    defaultErrMessage: "${StringConstants.please} ${StringConstants.checkYourInputAgain.toLowerCase()} "
        "${StringConstants.signIn.toLowerCase()}.",
  );

  final databaseRef = injector<RealtimeDatabaseService>();

  void onSignInSubmit(String phoneNumber, String password) async {
    print("phone $phoneNumber");
    print("password: $password");

    emit(state.copyWith(authEnum: AuthEnum.authenticating));

    final errorList = validateInput([phoneNumber, password]);

    for (var error in errorList) {
      if (error.isNotEmpty) {
        emit(state.copyWith(authEnum: AuthEnum.signInFailed));
        showAuthenticateResultToast(isSuccessful: false);
        return;
      }
    }

    //if there is no input error
    await _doSignIn(phoneNumber, password);
    // _doSignIn(phoneNumber, password);
  }

  Future<void> _doSignIn(String phoneNumber, String password) async {
    final deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["login"]}",
    ).set({
      "phoneNumber": phoneNumber, "password": password,
      "time": DateTime.now().toString(), "deviceToken": deviceToken,
    });
    databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["loginStatus"]}",
    ).onValue.listen((event) async {
      final data = Map<String, dynamic>.from((event.snapshot.value ?? {}) as Map<dynamic, dynamic>);
      print(data);
      if (data["phoneNumber"]?.toString().compareTo(phoneNumber) == 0) {
        if (data["successful"] == true) {
          await _onSignInSucceeded(
            data["phoneNumber"], data["username"], data["accountType"],
            data["token"], deviceToken,
          );
        } else {
          emit(state.copyWith(authEnum: AuthEnum.signInFailed));
          showAuthenticateResultToast(isSuccessful: false);
        }
      }
    });
  }

  Future<void> _onSignInSucceeded(String phone, String name, String type,
      String accessToken, String deviceToken,) async {
    injector<UserInfo>().setData(phone, name, type);
    await injector<LocalStorageManager>().setString(LocalStorageKeys.accessToken, accessToken);
    await injector<LocalStorageManager>().setString(LocalStorageKeys.deviceToken, deviceToken);
    emit(state.copyWith(authEnum: AuthEnum.signInSucceeded));
    showAuthenticateResultToast();
    Navigator.pushReplacementNamed(context!, RouteConstants.mainRoute);
  }
}
