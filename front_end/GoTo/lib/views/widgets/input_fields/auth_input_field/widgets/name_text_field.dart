import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/enums/text_field_type_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';
import 'package:go_to/views/widgets/input_fields/auth_input_field/widgets/auth_text_field.dart';

// class NameTextField extends StatefulWidget {
//   const NameTextField({
//     Key? key,
//     required this.textEditingController,
//     this.needValidateInput = false,
//   }) : super(key: key);
//
//   final TextEditingController textEditingController;
//   final bool needValidateInput;
//
//   @override
//   State<NameTextField> createState() => _NameTextFieldState();
// }
//
// class _NameTextFieldState extends State<NameTextField> {
//   @override
//   void initState() {
//     super.initState();
//     errorText = "";
//   }
//
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
//           if (!text.phoneNumberValidate()) {
//             setState(() => errorText = "${StringConstants.phoneNumber} ${StringConstants.not_valid}");
//           }
//           else {
//             setState(() => errorText = "");
//           }
//         }
//       },
//       decoration: InputDecoration(
//         alignLabelWithHint: true,
//         labelText: StringConstants.phoneNumber,
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
//       ),
//       keyboardType: TextInputType.number,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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

class NameTextField extends StatelessWidget {
  const NameTextField({
    Key? key,
    required this.textEditingController,
    this.needValidateInput = false,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final bool needValidateInput;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      type: TextFieldTypeEnums.name, replaceHintWithLabel: true,
      hintOrLabel: StringConstants.name,
      textEditingController: textEditingController, needValidateInput: needValidateInput,
    );
  }
}
