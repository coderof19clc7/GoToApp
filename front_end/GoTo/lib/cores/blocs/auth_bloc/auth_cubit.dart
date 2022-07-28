import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit<AuthState> extends Cubit<AuthState> {
  AuthCubit({
    required AuthState authState,
  }) : super(authState);
}
