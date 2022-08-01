import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/route_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/cores/blocs/auth_bloc/auth_cubit.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';

part 'sign_in_state.dart';

class SignInCubit extends AuthCubit<SignInState> {
  SignInCubit() : super(authState: const SignInState());

  BuildContext? context;

  void onSignInSubmit(String phoneNumber, String password) async {
    print("phone $phoneNumber");
    print("password: $password");

    emit(state.copyWith(authEnum: AuthEnum.authenticating));

    final errorList = validateInput([phoneNumber, password]);

    for (var error in errorList) {
      if (error.isNotEmpty) {
        emit(state.copyWith(authEnum: AuthEnum.signInFailed));
        _showFailedSignInToast();
        return;
      }
    }

    //if there is no input error
    await Future.delayed(const Duration(seconds: 5), () => _doSignIn(phoneNumber, password));
    // _doSignIn(phoneNumber, password);
  }

  void _doSignIn(String phoneNumber, String password) async {
    _onSignInSucceeded();
  }

  void _onSignInSucceeded() {
    emit(state.copyWith(authEnum: AuthEnum.signInSucceeded));
    UIHelper.showSuccessToast(
      "${StringConstants.signIn} ${StringConstants.success}.",
    );
    Navigator.pushReplacementNamed(context!, RouteConstants.mainRoute);
  }

  void _showFailedSignInToast() {
    UIHelper.showErrorToast(
      "${StringConstants.signIn} ${StringConstants.failed}.\n"
          "${StringConstants.please} ${StringConstants.checkYourInputAgain.toLowerCase()} "
          "${StringConstants.signIn.toLowerCase()}.",
    );
  }
}
