part of 'auth_cubit.dart';

@immutable
class AuthState {
  final List<String>? errorList;

  const AuthState({
    this.errorList,
  });
}
