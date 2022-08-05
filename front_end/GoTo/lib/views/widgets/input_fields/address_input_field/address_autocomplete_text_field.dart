import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_to/configs/constants/color_constants.dart';
import 'package:go_to/configs/constants/dimen_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/utilities/helpers/debounce_helper.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/home_cubit.dart';

class AddressAutocompleteTextField extends StatefulWidget {
  const AddressAutocompleteTextField({
    Key? key, this.suggestedLocationList = const [],
    this.suggestionApiFetching, this.onOptionSelected, this.onClearText
  }) : super(key: key);

  final List<SuggestedLocation>? suggestedLocationList;
  final FutureOr<Iterable<SuggestedLocation>> Function(String text)? suggestionApiFetching;
  final void Function(SuggestedLocation suggestedLocation)? onOptionSelected;
  final void Function()? onClearText;

  @override
  State<AddressAutocompleteTextField> createState() => _AddressAutocompleteTextFieldState();
}

class _AddressAutocompleteTextFieldState extends State<AddressAutocompleteTextField> {
  final debounceHelper = DebounceHelper();
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  String previousText = "";
  List<SuggestedLocation> previousListSuggestion = [];

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusNodeChanged);
  }

  void onFocusNodeChanged() {
    setState(() {});
    print(focusNode.hasFocus);
    if (textEditingController.text.isEmpty == true && focusNode.hasFocus == false) {
      //clear marker
      widget.onClearText?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<SuggestedLocation>(
      debounceDuration: const Duration(milliseconds: 500),
      hideSuggestionsOnKeyboardHide: !focusNode.hasFocus,
      suggestionsCallback: _suggestionsCallback,
      noItemsFoundBuilder: _buildNoItemFoundWidget,
      onSuggestionSelected: _onSuggestionSelected,
      textFieldConfiguration: _buildTextFieldConfiguration(),
      itemBuilder: _buildItem,
    );
  }

  FutureOr<Iterable<SuggestedLocation>> _suggestionsCallback(String text) async {
    if (text.isEmpty || text.compareTo(previousText) != 0) {
      previousText = text;
      previousListSuggestion = (await (widget.suggestionApiFetching?.call(text) ?? List<SuggestedLocation>.empty())).toList();
    }
    return previousListSuggestion;
  }

  Widget _buildNoItemFoundWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: DimenConstants.getProportionalScreenHeight(context, 200),
      width: DimenConstants.getScreenWidth(context) * 0.5,
      child: Center(
        child: Text(
          StringConstants.noResultFound,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: DimenConstants.getProportionalScreenWidth(context, 25),
            fontWeight: FontWeight.w600,
            color: ColorConstants.baseGrey,
          ),
        ),
      ),
    );
  }

  void _onSuggestionSelected(SuggestedLocation suggestedLocation) {
    textEditingController.text = suggestedLocation.name ?? "";
    previousText = textEditingController.text;
    widget.onOptionSelected?.call(suggestedLocation);
  }

  TextFieldConfiguration _buildTextFieldConfiguration() {
    return TextFieldConfiguration(
      controller: textEditingController,
      focusNode: focusNode,
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxWidth: DimenConstants.getScreenWidth(context) * 0.8,
          maxHeight: DimenConstants.getScreenHeight(context) * 0.5,
        ),
        suffixIcon: IconButton(
          splashColor: ColorConstants.baseWhite,
          padding: const EdgeInsets.all(0),
          onPressed: () {
            if (textEditingController.text.isNotEmpty == true) {
              textEditingController.text = "";
              setState(() {});
              if (focusNode.hasFocus == false) {
                //clear marker
                widget.onClearText?.call();
              }
            }
            else {
              if (focusNode.hasFocus) {
                UIHelper.hideKeyboard(context);
              }
            }
          },
          color: (focusNode.hasFocus == true || textEditingController.text.isNotEmpty == true)
              ? ColorConstants.baseBlack
              : ColorConstants.grey,
          icon: const Icon(Icons.close_rounded,),
        ),
      ),
      keyboardType: TextInputType.streetAddress,
    );
  }

  Widget _buildItem(BuildContext context, SuggestedLocation suggestedLocation) {
    final isSelfLocation = suggestedLocation.name?.compareTo(StringConstants.yourLocation) == 0;
    return ListTile(
      leading: Icon(
        isSelfLocation ? Icons.my_location : Icons.location_on,
        color: isSelfLocation
            ? ColorConstants.baseBlueAccent
            : ColorConstants.baseRed,
        size: DimenConstants.getProportionalScreenWidth(context, 30),
      ),
      title: Text(
        suggestedLocation.name ?? "",
        style: TextStyle(
          fontSize: DimenConstants.getProportionalScreenWidth(context, 17),
          fontWeight: FontWeight.w600,
          color: ColorConstants.baseBlack,
        ),
      ),
    );
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusNodeChanged);
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
