import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';

class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  @override
  void initState() {
    super.initState();
  }

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: StringConstants.phoneNumber,
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
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLines: 1,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}

