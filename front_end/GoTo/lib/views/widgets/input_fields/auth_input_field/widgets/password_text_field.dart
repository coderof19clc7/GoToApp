import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/text_field_type_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/widgets/auth_text_field.dart';

// class PasswordTextField extends StatefulWidget {
//   const PasswordTextField({
//     Key? key,
//     this.isConfirmPassword = false,
//     required this.textEditingController,
//     this.secondaryTextEditingController,
//     this.needValidateInput = false,
//   }) : super(key: key);
//
//   final bool isConfirmPassword;
//   final TextEditingController textEditingController;
//   final TextEditingController? secondaryTextEditingController;
//   final bool needValidateInput;
//
//   @override
//   State<PasswordTextField> createState() => _PasswordTextFieldState();
// }
//
// class _PasswordTextFieldState extends State<PasswordTextField> {
//   @override
//   void initState() {
//     super.initState();
//     showPassword = false;
//     errorText = "";
//   }
//
//   late bool showPassword;
//   final _focusNode = FocusNode();
//   late String errorText;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       focusNode: _focusNode,
//       controller: widget.textEditingController,
//       onChanged: (text) {
//         if (widget.needValidateInput) {
//           setState(() => errorText = "");
//           if (widget.isConfirmPassword) {
//             if (!text.confirmPasswordValidate(widget.secondaryTextEditingController?.text ?? "")) {
//               setState(() => errorText = "${StringConstants.confirm + StringConstants.password.toLowerCase()} "
//                   "${StringConstants.not_match_with.toLowerCase() + StringConstants.password.toLowerCase()}",);
//             }
//           }
//           else {
//             if (!text.passwordValidate()) {
//               setState(() => errorText = "${StringConstants.password} ${StringConstants.must_include.toLowerCase()}");
//             }
//           }
//         }
//       },
//       decoration: InputDecoration(
//         alignLabelWithHint: true,
//         labelText: widget.isConfirmPassword
//             ? "${StringConstants.confirm} ${StringConstants.password.toLowerCase()}"
//             : StringConstants.password,
//         labelStyle: TextStyle(
//           color: errorText.isNotEmpty
//               ? ColorConstants.baseRed
//               : _focusNode.hasFocus ? ColorConstants.orange : ColorConstants.grey,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(width: 1.5,color: ColorConstants.orange),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: const BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(width: 1.5,color: ColorConstants.grey),
//         ),
//         errorText: errorText.isNotEmpty ? errorText : null,
//         errorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(width: 1.5,color: ColorConstants.baseRed),
//         ),
//         focusedErrorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(4)),
//           borderSide: BorderSide(width: 1.5,color: ColorConstants.baseRed),
//         ),
//         suffixIcon: GestureDetector(
//           onTap: () => setState(() => showPassword = !showPassword),
//           child: Container(
//             margin: const EdgeInsets.only(right: 12),
//             child: showPassword
//                 ? Assets.svgs.eyeClose.svg(width: 35, color: ColorConstants.baseGrey,)
//                 : Assets.svgs.eyeOpen.svg(color: ColorConstants.baseGrey,),
//           ),
//         ),
//         suffixIconConstraints: const BoxConstraints(maxWidth: 40, maxHeight: 40,),
//       ),
//       obscureText: !showPassword,
//       keyboardType: TextInputType.visiblePassword,
//       maxLines: 1,
//     );
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
// }

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    Key? key,
    required this.textEditingController,
    required this.needValidateInput,
    this.isConfirmPassword = false,
    this.secondaryTextEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool needValidateInput;
  final bool isConfirmPassword;
  final TextEditingController? secondaryTextEditingController;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      type: isConfirmPassword ? TextFieldTypeEnums.confirmPassword : TextFieldTypeEnums.password,
      hintOrLabel: isConfirmPassword
          ? "${StringConstants.confirm} ${StringConstants.password.toLowerCase()}"
          : StringConstants.password,
      replaceHintWithLabel: true, needValidateInput: needValidateInput,
      textEditingController: textEditingController,
      secondaryTextEditingController: secondaryTextEditingController,
      suffixIconConstraints: BoxConstraints(
        maxWidth: DimenConstants.getProportionalScreenWidth(context, 35),
        maxHeight: DimenConstants.getProportionalScreenWidth(context, 35),
      ),
    );
  }
}