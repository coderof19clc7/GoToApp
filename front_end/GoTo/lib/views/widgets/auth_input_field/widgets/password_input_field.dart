import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';

class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    Key? key,
    this.isConfirmPassword = false,
    required this.textEditingController,
  }) : super(key: key);

  final bool isConfirmPassword;
  final TextEditingController textEditingController;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  @override
  void initState() {
    super.initState();
    showPassword = false;
  }

  late bool showPassword;
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: widget.isConfirmPassword
            ? "${StringConstants.confirm} ${StringConstants.password.toLowerCase()}"
            : StringConstants.password,
        labelStyle: TextStyle(
          color: _focusNode.hasFocus ? ColorConstants.orange : ColorConstants.grey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1.5,color: ColorConstants.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1.5,color: ColorConstants.grey),
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => showPassword = !showPassword),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: showPassword
                ? Assets.svgs.eyeClose.svg(width: 35, color: ColorConstants.baseGrey,)
                : Assets.svgs.eyeOpen.svg(color: ColorConstants.baseGrey,),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 40,),
      ),
      obscureText: !showPassword,
      keyboardType: TextInputType.visiblePassword,
      maxLines: 1,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
