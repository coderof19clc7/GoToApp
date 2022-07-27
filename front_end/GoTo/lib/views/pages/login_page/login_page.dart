import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/views/pages/login_page/bloc/login_cubit.dart';
import 'package:go_to/views/widgets/auth_input_field/auth_input_field.dart';
import 'package:go_to/views/widgets/buttons/rounded_rectangle_ink_well_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final phoneInputController = TextEditingController();
  final passwordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (contextLogin, state) {
        return Scaffold(
          body: Column(
            children: [
              //input field
              AuthInputField(
                phoneInputController: phoneInputController,
                passwordInputController: passwordInputController,
              ),
              const SizedBox(height: 10,),

              //forgot password button
              TextButton(
                onPressed: () {
                  print("Go to forgot password page.");
                },
                child: const Text(
                  StringConstants.forgotPassword,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              //sign in button
              RoundedRectangleInkWellButton(
                width: DimenConstants.getScreenWidth(context),
                height: DimenConstants.getScreenHeight(context),
                onTap: () {
                  print("phone: $phoneInputController.text");
                  print("password: $passwordInputController.text");
                },
                child: const Text(
                  StringConstants.signIn,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 7,),

              //sign up button
              TextButton(
                onPressed: () {
                  print("Go to sign up page.");
                },
                child: Text(
                  "${StringConstants.signUp} ${StringConstants.guestAccount.toLowerCase()}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    phoneInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }
}

