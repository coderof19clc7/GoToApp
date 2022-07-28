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
    return Column(
      children: [
        if (phoneInputController != null)
          ...[
            PhoneInputField(textEditingController: phoneInputController!),
          ],

        if (passwordInputController != null)
          ...[
            const SizedBox(height: 15,),
            PasswordInputField(textEditingController: passwordInputController!),
          ],

        if (confirmPasswordInputController != null)
          ...[
            const SizedBox(height: 15,),
            PasswordInputField(textEditingController: passwordInputController!, isConfirmPassword: true,),
          ],
      ],
    );
  }
}
