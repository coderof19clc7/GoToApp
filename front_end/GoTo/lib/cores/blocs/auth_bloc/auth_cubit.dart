import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';

part 'auth_state.dart';

abstract class AuthCubit<AuthState> extends Cubit<AuthState> {
  AuthCubit({
    required AuthState authState, required this.authAction,
    this.defaultErrMessage = "",
  }) : super(authState);

  final String defaultErrMessage;
  final String authAction;
  BuildContext? context;

  List<String> validateInput(List<String> input) {
    final length = input.length;
    List<String> errorList = [];
    for (int i = 0; i < length; i++) {
      if (input[i].isEmpty) {
        errorList.add(
            "${i == 0
                ? StringConstants.phoneNumber
                : i == 1 ? StringConstants.password
                : StringConstants.confirm +
                StringConstants.password.toLowerCase()} ${StringConstants.cannotBeEmpty.toLowerCase()}"
        );
      }
      else {
        if (i == 0) {
          if (!input[i].phoneNumberValidate()) {
            errorList.add("${StringConstants.phoneNumber} ${StringConstants.notValid.toLowerCase()}");
          }
          else {
            errorList.add("");
          }
        }
        else if (i == 1) {
          if (input[i].isEmpty) {
            errorList.add("${StringConstants.name} ${StringConstants.cannotBeEmpty.toLowerCase()}");
          }
          else {
            errorList.add("");
          }
        }
        else if (i == 2) {
          if (!input[i].passwordValidate()) {
            errorList.add("${StringConstants.password} ${StringConstants.mustInclude.toLowerCase()}");
          }
          else {
            errorList.add("");
          }
        }
        else {
          if (!input[i].confirmPasswordValidate(input[2])) {
            errorList.add(
              "${StringConstants.confirm} ${StringConstants.password.toLowerCase()} "
                  "${StringConstants.notMatchWith.toLowerCase()} ${StringConstants.password.toLowerCase()}",
            );
          }
          else {
            errorList.add("");
          }
        }
      }
    }

    return errorList;
  }

  @protected
  void showAuthenticateResultToast({bool isSuccessful = true, String message = ""}) {
    if (isSuccessful) {
      UIHelper.showSuccessToast("$authAction ${StringConstants.success.toLowerCase()}.",);
    }
    else {
      UIHelper.showErrorToast("$authAction ${StringConstants.failed.toLowerCase()}\n"
          "${message.isNotEmpty ? message : defaultErrMessage}");
    }
  }
}
