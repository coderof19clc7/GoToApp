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
    final needValidateInput = confirmPasswordInputController != null;
    return Column(
      children: [
        if (phoneInputController != null)
          ...[
            PhoneInputField(textEditingController: phoneInputController!, needValidateInput: needValidateInput,),
          ],

        if (passwordInputController != null)
          ...[
            const SizedBox(height: 15,),
            PasswordInputField(textEditingController: passwordInputController!, needValidateInput: needValidateInput,),
          ],

        if (confirmPasswordInputController != null)
          ...[
            const SizedBox(height: 15,),
            PasswordInputField(
              textEditingController: confirmPasswordInputController!, isConfirmPassword: true,
              textSecondaryEditingController: passwordInputController!, needValidateInput: needValidateInput,
            ),
          ],
      ],
    );
  }
}
