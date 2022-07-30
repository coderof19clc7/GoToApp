import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/text_field_type_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';
import 'package:go_to/utilities/extensions/string_extensions.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    Key? key, this.type = TextFieldTypeEnums.normal,
    required this.textEditingController,
    this.secondaryTextEditingController,
    this.needValidateInput = false, this.hintOrLabel,
    this.replaceHintWithLabel = false,
    this.suffixIconConstraints,
  }) : super(key: key);

  final TextFieldTypeEnums type;
  final TextEditingController textEditingController;
  final TextEditingController? secondaryTextEditingController;
  final bool needValidateInput, replaceHintWithLabel;
  final String? hintOrLabel;
  final BoxConstraints? suffixIconConstraints;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  void initState() {
    super.initState();
    _errorText = "";
    _obscureText = (
        widget.type == TextFieldTypeEnums.password ||
            widget.type == TextFieldTypeEnums.confirmPassword
    );
  }

  final _focusNode = FocusNode();
  late String _errorText;
  late bool _obscureText;

  void _onChanged(String text) {
    bool validateText(String text) {
      switch(widget.type) {
        case TextFieldTypeEnums.phone:
          return text.phoneNumberValidate();
        case TextFieldTypeEnums.name:
          return text.isNotEmpty;
        case TextFieldTypeEnums.password:
          return text.passwordValidate();
        case TextFieldTypeEnums.confirmPassword:
          return text.confirmPasswordValidate(widget.secondaryTextEditingController?.text ?? "");
        case TextFieldTypeEnums.normal:
          return true;
      }
    }
    String getErrorText() {
      switch(widget.type) {
        case TextFieldTypeEnums.phone:
          return "${StringConstants.phoneNumber} ${StringConstants.not_valid}";
        case TextFieldTypeEnums.name:
          return "${StringConstants.name} ${StringConstants.cannot_be_empty}";
        case TextFieldTypeEnums.password:
          return "${StringConstants.password} ${StringConstants.must_include.toLowerCase()}";
        case TextFieldTypeEnums.confirmPassword:
          return "${StringConstants.confirm + StringConstants.password.toLowerCase()} "
              "${StringConstants.not_match_with.toLowerCase() + StringConstants.password.toLowerCase()}";
        case TextFieldTypeEnums.normal:
          return "";
      }
    }
    if (widget.needValidateInput){
      if (!validateText(text)) {
        setState(() => _errorText = getErrorText());
      } else {
        setState(() => _errorText = "");
      }
    }
  }

  TextInputType _getTextInputType() {
    switch(widget.type) {
      case TextFieldTypeEnums.phone:
        return TextInputType.phone;
      case TextFieldTypeEnums.name:
        return TextInputType.name;
      case TextFieldTypeEnums.password:
        return TextInputType.visiblePassword;
      case TextFieldTypeEnums.confirmPassword:
        return TextInputType.visiblePassword;
      case TextFieldTypeEnums.normal:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getListTextInputFormatter() {
    switch(widget.type) {
      case TextFieldTypeEnums.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default: return null;
    }
  }

  Widget? buildSuffixIcon() {
    switch(widget.type) {
      case TextFieldTypeEnums.password:
      case TextFieldTypeEnums.confirmPassword:
        return GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: Container(
            margin: EdgeInsets.only(right: DimenConstants.getProportionalScreenWidth(context, 12)),
            child: !_obscureText
                ? Assets.svgs.eyeClose.svg(
              width: DimenConstants.getProportionalScreenWidth(context, 30),
              color: ColorConstants.baseGrey,
            )
                : Assets.svgs.eyeOpen.svg(color: ColorConstants.baseGrey,),
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.textEditingController,
      onChanged: _onChanged,
      decoration: InputDecoration(
        alignLabelWithHint: widget.replaceHintWithLabel,
        labelText: widget.replaceHintWithLabel ? widget.hintOrLabel : null,
        labelStyle: TextStyle(
          color: _errorText.isNotEmpty
              ? ColorConstants.baseRed
              : _focusNode.hasFocus ? ColorConstants.orange : ColorConstants.grey,
        ),
        hintText: !widget.replaceHintWithLabel ? widget.hintOrLabel : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: DimenConstants.getProportionalScreenWidth(context, 1.5),
            color: ColorConstants.orange,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: DimenConstants.getProportionalScreenWidth(context, 1.5),
            color: ColorConstants.grey,
          ),
        ),
        errorText: _errorText.isNotEmpty ? _errorText : null,
        errorMaxLines: 2,
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: DimenConstants.getProportionalScreenWidth(context, 1.5),
            color: ColorConstants.baseRed,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: DimenConstants.getProportionalScreenWidth(context, 1.5),
            color: ColorConstants.baseRed,
          ),
        ),
        suffixIcon: buildSuffixIcon(),
        suffixIconConstraints: widget.suffixIconConstraints,
      ),
      obscureText: _obscureText,
      keyboardType: _getTextInputType(),
      inputFormatters: _getListTextInputFormatter(),
      maxLines: 1,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
