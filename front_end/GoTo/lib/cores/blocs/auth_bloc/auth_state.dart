part of 'auth_cubit.dart';

@immutable
class AuthState {
  const AuthState({
    this.authEnum,
  });

  final AuthEnum? authEnum;
}
