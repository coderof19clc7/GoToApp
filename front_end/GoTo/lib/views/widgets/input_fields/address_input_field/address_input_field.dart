import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';
import 'package:go_to/views/widgets/icons/location_icons/end_location_icon.dart';
import 'package:go_to/views/widgets/icons/location_icons/start_location_icon.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_autocomplete_text_field.dart';

class AddressInputField extends StatefulWidget {
  const AddressInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddressInputFieldState();
}

class AddressInputFieldState extends State<AddressInputField> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (contextHome, state) {
        return Column(
          children: [
            _buildChild(
              context, onTextChanged: (text) => contextHome.read<HomeCubit>().getSuggestedList(
                LocationEnums.startPoint, text),
              onOptionSelected: (text) => contextHome.read<HomeCubit>().addMarkerListAt(
                  LocationEnums.startPoint, text),
              onClearText: () => contextHome.read<HomeCubit>().removeMarkerListAt(LocationEnums.startPoint),
              icon: const StartLocationIcon(),
            ),
            SizedBox(
              height: DimenConstants.getProportionalScreenHeight(context, 8),),

            _buildChild(
              context, onTextChanged: (text) => contextHome.read<HomeCubit>().getSuggestedList(
                LocationEnums.endPoint, text),
              onOptionSelected: (text) => contextHome.read<HomeCubit>().addMarkerListAt(
                  LocationEnums.endPoint, text),
              onClearText: () => contextHome.read<HomeCubit>().removeMarkerListAt(LocationEnums.endPoint),
              icon: const EndLocationIcon(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, {
    required Widget icon,
    FutureOr<Iterable<SuggestedLocation>> Function(String text)? onTextChanged,
    void Function(SuggestedLocation suggestedLocation)? onOptionSelected,
    void Function()? onClearText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //if user is client
        icon,
        SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8),),
        AddressAutocompleteTextField(
          onTextChanged: onTextChanged,
          onOptionSelected: onOptionSelected,
          onClearText: onClearText,
        ),
        SizedBox(
          width: DimenConstants.getProportionalScreenWidth(context, 12),),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
