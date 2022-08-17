import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/models/infos/location_info.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/client_home_page/blocs/client_home_cubit.dart';
import 'package:go_to/views/widgets/icons/location_icons/end_location_icon.dart';
import 'package:go_to/views/widgets/icons/location_icons/start_location_icon.dart';
import 'package:go_to/views/widgets/input_fields/address_input_field/address_autocomplete_text_field.dart';

class AddressInputField extends StatefulWidget {
  const AddressInputField({
    Key? key, this.enableInputField = true,
    this.startPointOnClearText, this.startPointOnOptionSelected,
    this.startPointSuggestionApiFetching, this.startTextEditingController,
    this.endPointOnClearText, this.endPointOnOptionSelected,
    this.endPointSuggestionApiFetching, this.endTextEditingController,
  }) : super(key: key);

  final bool enableInputField;
  //startPoint
  final TextEditingController? startTextEditingController;
  final FutureOr<Iterable<LocationInfo>> Function(String text)? startPointSuggestionApiFetching;
  final void Function(LocationInfo suggestedLocation)? startPointOnOptionSelected;
  final void Function()? startPointOnClearText;
  //endPoint
  final TextEditingController? endTextEditingController;
  final FutureOr<Iterable<LocationInfo>> Function(String text)? endPointSuggestionApiFetching;
  final void Function(LocationInfo suggestedLocation)? endPointOnOptionSelected;
  final void Function()? endPointOnClearText;

  @override
  State<StatefulWidget> createState() => AddressInputFieldState();
}

class AddressInputFieldState extends State<AddressInputField> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientHomeCubit, ClientHomeState>(
      builder: (contextHome, state) {
        return Column(
          children: [
            //startPoint input field
            _buildChild(
              context, textEditingController: widget.startTextEditingController,
              suggestionApiFetching: widget.startPointSuggestionApiFetching,
              onOptionSelected: widget.startPointOnOptionSelected,
              onClearText: widget.startPointOnClearText,
              icon: const StartLocationIcon(),
            ),

            SizedBox(
              height: DimenConstants.getProportionalScreenHeight(context, 8),
            ),

            //endPoint input field
            _buildChild(
              context, textEditingController: widget.endTextEditingController,
              suggestionApiFetching: widget.endPointSuggestionApiFetching,
              onOptionSelected: widget.endPointOnOptionSelected,
              onClearText: widget.endPointOnClearText,
              icon: const EndLocationIcon(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChild(BuildContext context, {
    required Widget icon, TextEditingController? textEditingController,
    FutureOr<Iterable<LocationInfo>> Function(String text)? suggestionApiFetching,
    void Function(LocationInfo suggestedLocation)? onOptionSelected,
    void Function()? onClearText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8),),
        AddressAutocompleteTextField(
          enableTextField: widget.enableInputField,
          textEditingController: textEditingController ?? TextEditingController(),
          suggestionApiFetching: suggestionApiFetching,
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
