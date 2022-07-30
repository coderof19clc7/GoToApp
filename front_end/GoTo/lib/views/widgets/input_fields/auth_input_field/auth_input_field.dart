import 'package:flutter/material.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/widgets/name_text_field.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/widgets/password_text_field.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/widgets/phone_text_field.dart';

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    Key? key,
    this.needValidateInput = false,
    this.phoneInputController, this.nameInputController,
    this.passwordInputController, this.confirmPasswordInputController,
  }) : super(key: key);

  final bool needValidateInput;
  final TextEditingController? phoneInputController;
  final TextEditingController? nameInputController;
  final TextEditingController? passwordInputController;
  final TextEditingController? confirmPasswordInputController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (phoneInputController != null) ...[
          PhoneTextField(
            textEditingController: phoneInputController!, needValidateInput: needValidateInput,
          ),
        ],
        if (nameInputController != null) ...[
          const SizedBox(height: 15,),
          NameTextField(
            textEditingController: nameInputController!, needValidateInput: needValidateInput,
          ),
        ],
        if (passwordInputController != null) ...[
          const SizedBox(height: 15,),
          PasswordTextField(
            textEditingController: passwordInputController!, needValidateInput: needValidateInput,
          ),
        ],
        if (confirmPasswordInputController != null) ...[
          const SizedBox(height: 15,),
          PasswordTextField(
            textEditingController: confirmPasswordInputController!,
            isConfirmPassword: true,
            secondaryTextEditingController: passwordInputController!,
            needValidateInput: needValidateInput,
          ),
        ],
      ],
    );
  }
}
