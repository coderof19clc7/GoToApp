part of 'sign_up_cubit.dart';

@immutable
class SignUpState extends AuthState{
  const SignUpState({
    super.authEnum,
  });

  SignUpState copyWith({
    AuthEnum? authEnum,
  }) {
    return SignUpState(authEnum: authEnum ?? this.authEnum);
  }
}
