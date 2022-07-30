import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/auth_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:go_to/views/pages/sign_up_page/bloc/sign_up_cubit.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/auth_input_field.dart';
import 'package:go_to/views/widgets/buttons/rounded_rectangle_ink_well_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: const SignUpPageView(),
    );
  }
}

class SignUpPageView extends StatefulWidget {
  const SignUpPageView({Key? key}) : super(key: key);

  @override
  State<SignUpPageView> createState() => _SignUpPageViewState();
}

class _SignUpPageViewState extends State<SignUpPageView> {
  final phoneInputController = TextEditingController();
  final passwordInputController = TextEditingController();
  final nameInputController = TextEditingController();
  final confirmPasswordInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (contextSignUp, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
              onTap: () {
                UIHelper.hideKeyboard(context);
              },
              child: Container(
                width: double.infinity, height: double.infinity,
                padding: EdgeInsets.only(
                  left: DimenConstants.getProportionalScreenWidth(context, 17),
                  right: DimenConstants.getProportionalScreenWidth(context, 17),
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: DimenConstants.getScreenHeight(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: DimenConstants.getProportionalScreenHeight(context, 20),
                        ),

                        //back button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            size: DimenConstants.getProportionalScreenWidth(context, 35),
                            color: ColorConstants.orange,
                          ),
                        ),
                        SizedBox(
                          height: DimenConstants.getProportionalScreenHeight(context, 50),
                        ),

                        //input field
                        AuthInputField(
                          needValidateInput: true,
                          phoneInputController: phoneInputController,
                          nameInputController: nameInputController,
                          passwordInputController: passwordInputController,
                          confirmPasswordInputController: confirmPasswordInputController,
                        ),
                        SizedBox(
                          height: DimenConstants.getProportionalScreenHeight(context, 20),
                        ),

                        //sign up button
                        RoundedRectangleInkWellButton(
                          width: DimenConstants.getScreenWidth(context),
                          height: DimenConstants.getProportionalScreenHeight(context, 60),
                          paddingVertical: DimenConstants.getProportionalScreenHeight(context, 10),
                          bgLinearGradient: LinearGradient(colors: ColorConstants.defaultOrangeList),
                          onTap: () {
                            UIHelper.hideKeyboard(context);
                            contextSignUp.read<SignUpCubit>().onSignUpSubmit(
                              phoneInputController.text,
                              nameInputController.text,
                              passwordInputController.text,
                              confirmPasswordInputController.text,
                            );
                          },
                          child: state.authEnum == AuthEnum.authenticating
                              ? const CircularProgressIndicator(color: ColorConstants.baseWhite,)
                              : Text(
                            StringConstants.signUp,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: DimenConstants.getProportionalScreenWidth(context, 25),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    phoneInputController.dispose();
    passwordInputController.dispose();
    nameInputController.dispose();
    confirmPasswordInputController.dispose();
    super.dispose();
  }
}
