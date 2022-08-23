import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/auth_bloc/auth_cubit.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';

part 'sign_up_state.dart';

class SignUpCubit extends AuthCubit<SignUpState> {
  SignUpCubit() : super(
    authState: const SignUpState(), authAction: StringConstants.signUp,
    defaultErrMessage: "${StringConstants.please} ${StringConstants.checkYourInputAgain.toLowerCase()} "
        "${StringConstants.signUp.toLowerCase()}.",
  );

  final databaseRef = injector<RealtimeDatabaseService>();

  void onSignUpSubmit(String phoneNumber, String name, String password, String confirmPassword) async {
    print("phone $phoneNumber");
    print("name: $name");
    print("password $password");
    print("confirm password: $confirmPassword");

    emit(state.copyWith(authEnum: AuthEnum.authenticating));

    final errorList = validateInput([phoneNumber, name, password, confirmPassword]);

    for (var error in errorList) {
      if (error.isNotEmpty) {
        emit(state.copyWith(authEnum: AuthEnum.signInFailed));
        showAuthenticateResultToast(isSuccessful: false);
        return;
      }
    }

    //if there is no input error
    await _doSignUp(phoneNumber, name, password);
  }

  Future<void> _doSignUp(String phoneNumber, String name, String password) async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["register"]}",
    ).set({
      "phoneNumber": phoneNumber, "password": password, "accountType": "Customer",
      "name": name, "time": UIHelper.getTimeStamp(),
    });
    authListener = databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["registerStatus"]}",
    ).onValue.listen((event) async {
      final data = Map<String, dynamic>.from((event.snapshot.value ?? {}) as Map<dynamic, dynamic>);
      print(data);
      if (data["phoneNumber"]?.toString().compareTo(phoneNumber) == 0) {
        if (data["successful"] == true) {
          _onSignUpSucceeded();
        } else {
          emit(state.copyWith(authEnum: AuthEnum.signInFailed));
          showAuthenticateResultToast(isSuccessful: false, message:  "${data["error"]}",);
        }
        authListener?.cancel();
      }
    });
  }

  void _onSignUpSucceeded() {
    emit(state.copyWith(authEnum: AuthEnum.signUpSucceeded));
    showAuthenticateResultToast();
    Timer(
      const Duration(seconds: 3), () => Navigator.pop(context!),
    );
  }
}
