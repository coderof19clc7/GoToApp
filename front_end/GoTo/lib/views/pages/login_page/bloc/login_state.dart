part of 'login_cubit.dart';

@immutable
class LoginState extends AuthState {
  const LoginState({
    this.authEnum,
  });

  final AuthEnum? authEnum;

  LoginState copyWith({
    AuthEnum? authEnum,
  }) {
    return LoginState(
      authEnum: authEnum ?? this.authEnum,
    );
  }
}
