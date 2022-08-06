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
import 'package:go_to/utilities/helpers/ui_helper.dart';

part 'sign_in_state.dart';

class SignInCubit extends AuthCubit<SignInState> {
  SignInCubit() : super(authState: const SignInState());

  BuildContext? context;
  final databaseRef = injector<RealtimeDatabaseService>();

  void onSignInSubmit(String phoneNumber, String password) async {
    print("phone $phoneNumber");
    print("password: $password");

    emit(state.copyWith(authEnum: AuthEnum.authenticating));

    final errorList = validateInput([phoneNumber, password]);

    for (var error in errorList) {
      if (error.isNotEmpty) {
        emit(state.copyWith(authEnum: AuthEnum.signInFailed));
        _showSignInResultToast(isSuccessful: false);
        return;
      }
    }

    //if there is no input error
    await Future.delayed(const Duration(seconds: 5), () => _doSignIn(phoneNumber, password));
    // _doSignIn(phoneNumber, password);
  }

  void _doSignIn(String phoneNumber, String password) async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["login"]}/$phoneNumber",
    ).set({
      "password": password, "time": DateTime.now().toString(),
    });
    // databaseRef.ref.child(
    //   "${FirebaseConstants.databaseChildPath["loginStatus"]}/$phoneNumber",
    // ).onValue.listen((event) async {
    //   final data = event.snapshot.value as Map<String, dynamic>?;
    //   if (data != null) {
    //     if (data["successful"] == true) {
    //       await _onSignInSucceeded(data["phoneNumber"], data["username"], data["accountType"], data["token"]);
    //     }
    //     else {
    //       emit(state.copyWith(authEnum: AuthEnum.signInFailed));
    //       _showSignInResultToast(isSuccessful: false);
    //     }
    //   }
    // });
    await _onSignInSucceeded(phoneNumber, "ABC", "Customer", "moc_token");
  }

  Future<void> _onSignInSucceeded(String phone, String name, String type, String accessToken) async {
    injector<UserInfo>().setData(phone, name, type);
    await injector<LocalStorageManager>().setString(LocalStorageKeys.accessToken, accessToken);
    emit(state.copyWith(authEnum: AuthEnum.signInSucceeded));
    _showSignInResultToast();
    Navigator.pushReplacementNamed(context!, RouteConstants.mainRoute);
  }

  void _showSignInResultToast({bool isSuccessful = true}) {
    if (isSuccessful) {
      UIHelper.showSuccessToast(
        "${StringConstants.signIn} ${StringConstants.success}.",
      );
    }
    else {
      UIHelper.showErrorToast(
        "${StringConstants.signIn} ${StringConstants.failed}.\n"
            "${StringConstants.please} ${StringConstants.checkYourInputAgain.toLowerCase()} "
            "${StringConstants.signIn.toLowerCase()}.",
      );
    }
  }
}
