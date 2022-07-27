import 'package:flutter/material.dart';
import 'package:go_to/views/widgets/auth_input_field/widgets/password_input_field.dart';
import 'package:go_to/views/widgets/auth_input_field/widgets/password_input_field.dart';
import 'package:go_to/views/widgets/auth_input_field/widgets/phone_input_field.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    Key? key,
    this.phoneInputController,
    this.passwordInputController,
    this.confirmPasswordInputController,
  }) : super(key: key);

  final TextEditingController? phoneInputController;
  final TextEditingController? passwordInputController;
  final TextEditingController? confirmPasswordInputController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        children: [
          phoneInputController != null
              ? PhoneInputField(textEditingController: phoneInputController!)
              : const SizedBox(),
          const SizedBox(height: 8,),

          passwordInputController != null
              ? PasswordInputField(textEditingController: passwordInputController!)
              : const SizedBox(),
          const SizedBox(height: 8,),

          confirmPasswordInputController != null
              ? PasswordInputField(textEditingController: confirmPasswordInputController!)
              : const SizedBox(),
        ],
      ),
    );
  }
}
