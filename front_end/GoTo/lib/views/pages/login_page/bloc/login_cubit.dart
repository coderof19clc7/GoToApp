import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/cores/blocs/auth_bloc/auth_cubit.dart';

part 'login_state.dart';

class LoginCubit extends AuthCubit<LoginState> {
  LoginCubit() : super(authState: LoginState());

  void onSignInSubmit(String phoneNumber, String password) {
    print("phone $phoneNumber");
    print("password: $password");


  }
}
