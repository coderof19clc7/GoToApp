part of 'sign_in_cubit.dart';

@immutable
class SignInState extends AuthState {
  const SignInState({
    super.authEnum,
  });

  SignInState copyWith({
    AuthEnum? authEnum,
  }) {
    return SignInState(
      authEnum: authEnum ?? this.authEnum,
    );
  }
}
