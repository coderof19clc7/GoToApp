import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';

part 'auth_state.dart';

abstract class AuthCubit<AuthState> extends Cubit<AuthState> {
  AuthCubit({
    required AuthState authState,
  }) : super(authState);

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
                StringConstants.password.toLowerCase()} ${StringConstants.cannot_be_empty.toLowerCase()}"
        );
      }
      else {
        if (i == 0) {
          if (!input[i].phoneNumberValidate()) {
            errorList.add("${StringConstants.phoneNumber} ${StringConstants.not_valid.toLowerCase()}");
          }
          else {
            errorList.add("");
          }
        }
        else if (i == 1) {
          if (!input[i].passwordValidate()) {
            errorList.add("${StringConstants.password} ${StringConstants.must_include.toLowerCase()}");
          }
          else {
            errorList.add("");
          }
        }
        else {
          if (!input[i].confirmPasswordValidate(input[1])) {
            errorList.add(
              "${StringConstants.confirm + StringConstants.password.toLowerCase()} "
                  "${StringConstants.not_match_with.toLowerCase() + StringConstants.password.toLowerCase()}",
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
}
