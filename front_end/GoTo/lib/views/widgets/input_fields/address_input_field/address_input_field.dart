import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/generated/flutter_gen/assets.gen.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_autocomplete_text_field.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    final TextEditingController textEditingController2 = TextEditingController();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (contextHome, state) {
        return Column(
          children: [
            _buildChild(
              context, onTextChanged: () => contextHome.read<HomeCubit>().getSuggestedList(0, textEditingController.text),
              textEditingController: textEditingController,
              icon: Assets.svgs.doubleCircle.svg(
                width: DimenConstants.getProportionalScreenWidth(context, 30),
                height: DimenConstants.getProportionalScreenWidth(context, 30),
                color: ColorConstants.baseBlueAccent,
              ),
            ),
            SizedBox(
              height: DimenConstants.getProportionalScreenHeight(context, 8),),

            _buildChild(
              context, onTextChanged: () => contextHome.read<HomeCubit>().getSuggestedList(1, textEditingController2.text),
              textEditingController: textEditingController2,
              icon: Icon(
                Icons.location_on, color: ColorConstants.baseRed,
                size: DimenConstants.getProportionalScreenWidth(context, 30),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, {
    required TextEditingController textEditingController, required Widget icon,
    void Function()? onTextChanged, void Function()? onClearText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //if user is client
        icon,
        SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8),),
        AddressAutocompleteTextField(
          textEditingController: textEditingController,
          onTextChanged: onTextChanged,
        ),
        SizedBox(
          width: DimenConstants.getProportionalScreenWidth(context, 12),),
      ],
    );
  }
}
