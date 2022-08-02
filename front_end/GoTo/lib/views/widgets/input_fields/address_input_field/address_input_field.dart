import 'package:flutter/material.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_autocomplete_text_field.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField({
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
        _buildChild(
          context, callback: () {},
          icon: Icon(
            Icons.my_location_rounded, color: ColorConstants.baseBlueAccent,
            size: DimenConstants.getProportionalScreenWidth(context, 30),
          ),
        ),
        SizedBox(height: DimenConstants.getProportionalScreenHeight(context, 8),),

        _buildChild(
          context, callback: () {},
          icon: Icon(
            Icons.location_on, color: ColorConstants.baseRed,
            size: DimenConstants.getProportionalScreenWidth(context, 30),
          ),
        ),
      ],
    );
  }

  Widget _buildChild(BuildContext context, {
    required Widget icon, required void Function() callback,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //if user is client
        icon, SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8),),
        const AddressAutocompleteTextField(),
        SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 12),),
      ],
    );
  }
}
