import 'package:bloc/bloc.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/cores/blocs/auth_bloc/auth_cubit.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends AuthCubit<SignUpState> {
  SignUpCubit() : super(authState: const SignUpState());

  void onSignUpSubmit(String phoneNumber, String name, String password, String confirmPassword) {
    print("phone $phoneNumber");
    print("password: $name");
    print("phone $password");
    print("password: $confirmPassword");

    emit(state.copyWith(authEnum: AuthEnum.authenticating));

    final errorList = validateInput([phoneNumber, name, password, confirmPassword]);

    for (var error in errorList) {
      if (error.isNotEmpty) {
        emit(state.copyWith(authEnum: AuthEnum.signInFailed));
        _showFailedSignInToast();
        return;
      }
    }

    //if there is no input error
    Future.delayed(const Duration(seconds: 5), () => _doSignUp(
      phoneNumber, name, password, confirmPassword,
    ));
  }

  void _doSignUp(String phoneNumber, String name, String password, String confirmPassword) {
    _onSignUpSucceeded();
  }

  void _onSignUpSucceeded() {
    emit(state.copyWith(authEnum: AuthEnum.signUpSucceeded));
    UIHelper.showSuccessToast(
      "${StringConstants.signUp} ${StringConstants.success}.",
    );
  }

  void _showFailedSignInToast() {
    UIHelper.showErrorToast(
        "${StringConstants.signUp} ${StringConstants.failed}.\n"
            "${StringConstants.please} ${StringConstants.checkYourInputAgain.toLowerCase()} "
            "${StringConstants.signUp.toLowerCase()}."
    );
  }
}
