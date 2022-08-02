import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/utilities/debounce_helper.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';

class AddressAutocompleteTextField extends StatefulWidget {
  const AddressAutocompleteTextField({
    Key? key,
  }) : super(key: key);

  @override
  State<AddressAutocompleteTextField> createState() => _AddressAutocompleteTextFieldState();
}

class _AddressAutocompleteTextFieldState extends State<AddressAutocompleteTextField> {
  final debounceHelper = DebounceHelper();
  final focusNode = FocusNode();
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      optionsBuilder: (textEditingValue) {
        return List<String>.empty();
      },
      fieldViewBuilder: _buildTextField,
    );
  }

  Widget _buildTextField(
      BuildContext context,
      TextEditingController autoCompleteTextEditingController,
      FocusNode autoCompleteFocusNode, void Function() function
  ) {
    return Container(
      width: DimenConstants.getScreenWidth(context) * 0.8,
      padding: EdgeInsets.only(
        left: DimenConstants.getProportionalScreenWidth(context, 17),
        right: DimenConstants.getProportionalScreenWidth(context, 4),
        top: DimenConstants.getProportionalScreenHeight(context, 12),
        bottom: DimenConstants.getProportionalScreenHeight(context, 12),
      ),
      decoration: BoxDecoration(
        color: ColorConstants.baseWhite,
        boxShadow: [
          BoxShadow(
            color: ColorConstants.grey,
            offset: const Offset(2, 4),
            blurRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        focusNode: focusNode,
        controller: textEditingController,
        onChanged: (text) {
          debounceHelper.runTextChange(() => print(text.isNotEmpty ? text : "empty"));
        },
        keyboardType: TextInputType.streetAddress,
        maxLines: 1,
        cursorColor: ColorConstants.baseOrange,
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: IconButton(
            splashColor: ColorConstants.baseWhite,
            padding: const EdgeInsets.all(0),
            onPressed: () {
              if (textEditingController.text.isNotEmpty) {
                textEditingController.clear();
                setState(() {});
              }
              else {
                if (!focusNode.hasFocus) return;
                UIHelper.hideKeyboard(context);
              }
            },
            color: (focusNode.hasFocus || textEditingController.text.isNotEmpty)
                ? ColorConstants.baseBlack
                : ColorConstants.grey,
            icon: const Icon(Icons.close_rounded,),
          ),
        ),
        style: TextStyle(
          fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
          color: ColorConstants.baseBlack,
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChanged);
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
