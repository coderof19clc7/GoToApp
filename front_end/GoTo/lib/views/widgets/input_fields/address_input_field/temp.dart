// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:go_to/configs/constants/color_constants.dart';
// import 'package:go_to/configs/constants/dimen_constants.dart';
// import 'package:go_to/configs/constants/string_constants.dart';
// import 'package:go_to/utilities/debounce_helper.dart';
// import 'package:go_to/utilities/helpers/ui_helper.dart';
//
// class AddressAutocompleteTextField extends StatefulWidget {
//   const AddressAutocompleteTextField({
//     Key? key, this.onTextChanged,
//     required this.onOptionSelected,
//   }) : super(key: key);
//
//   final FutureOr<Iterable<String>> Function(String text)? onTextChanged;
//   final void Function(String text) onOptionSelected;
//
//   @override
//   State<AddressAutocompleteTextField> createState() => _AddressAutocompleteTextFieldState();
// }
//
// class _AddressAutocompleteTextFieldState extends State<AddressAutocompleteTextField> {
//   final debounceHelper = DebounceHelper();
//   FocusNode? focusNode;
//   TextEditingController? textEditingController;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void onFocusChanged() {
//     setState(() {});
//     if (textEditingController?.text.isEmpty == true) {
//       if (focusNode?.hasFocus == false) {
//
//       }
//       else {
//         widget.onTextChanged?.call(textEditingController?.text ?? "");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Autocomplete<String>(
//       optionsBuilder: _optionsBuilder,
//       optionsViewBuilder: _buildOptionsView,
//       onSelected: widget.onOptionSelected,
//       fieldViewBuilder: _buildTextField,
//     );
//   }
//
//   FutureOr<Iterable<String>> _optionsBuilder(TextEditingValue textEditingValue) async {
//     final suggestedLocationNameList = await widget.onTextChanged?.call(textEditingValue.text) ?? [];
//     if (suggestedLocationNameList.isEmpty == true) {
//       return [StringConstants.noResultFound];
//     }
//     return suggestedLocationNameList;
//   }
//   Widget _buildOptionsView(BuildContext context, void Function(String) onSelected, Iterable<String> listString) {
//     if (listString.length == 1 && listString.elementAt(0).compareTo(StringConstants.noResultFound) == 0) {
//       return Container(
//         alignment: Alignment.center,
//         height: DimenConstants.getProportionalScreenHeight(context, 50),
//         width: DimenConstants.getScreenWidth(context) * 0.5,
//         child: Text(
//           listString.elementAt(0), style: TextStyle(
//           fontSize: DimenConstants.getProportionalScreenWidth(context, 25),
//           fontWeight: FontWeight.w600,
//           color: ColorConstants.baseGrey,
//         ),
//         ),
//       );
//     }
//     return Material(
//       child: ListView.builder(
//         itemCount: listString.length,
//         itemBuilder: (BuildContext context, int index) {
//           final isSelfLocation = listString.elementAt(index).compareTo(StringConstants.yourLocation) == 0;
//           return ListTile(
//             leading: Icon(
//               isSelfLocation ? Icons.my_location : Icons.location_on,
//               color: isSelfLocation ? ColorConstants.baseBlueAccent : ColorConstants.baseRed,
//               size: DimenConstants.getProportionalScreenWidth(context, 30),
//             ),
//             title: Text(
//               listString.elementAt(index), style: TextStyle(
//               fontSize: DimenConstants.getProportionalScreenWidth(context, 17),
//               fontWeight: FontWeight.w600, color: ColorConstants.baseBlack,
//             ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//   Widget _buildTextField(
//       BuildContext context,
//       TextEditingController autoCompleteTextEditingController,
//       FocusNode autoCompleteFocusNode, void Function() function
//       ) {
//     textEditingController = autoCompleteTextEditingController;
//     focusNode = autoCompleteFocusNode;
//     focusNode?.addListener(onFocusChanged);
//     return Container(
//       width: DimenConstants.getScreenWidth(context) * 0.8,
//       padding: EdgeInsets.only(
//         left: DimenConstants.getProportionalScreenWidth(context, 17),
//         right: DimenConstants.getProportionalScreenWidth(context, 4),
//         top: DimenConstants.getProportionalScreenHeight(context, 12),
//         bottom: DimenConstants.getProportionalScreenHeight(context, 12),
//       ),
//       decoration: BoxDecoration(
//         color: ColorConstants.baseWhite,
//         boxShadow: [
//           BoxShadow(
//             color: ColorConstants.grey,
//             offset: const Offset(2, 4),
//             blurRadius: 3,
//           ),
//         ],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         focusNode: focusNode,
//         controller: textEditingController,
//         onChanged: (text) {
//           debounceHelper.runTextChange(() {
//             print(text.isNotEmpty ? text : "empty");
//             widget.onTextChanged?.call(textEditingController?.text ?? "");
//           });
//         },
//         keyboardType: TextInputType.streetAddress,
//         maxLines: 1,
//         cursorColor: ColorConstants.baseOrange,
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           suffixIcon: IconButton(
//             splashColor: ColorConstants.baseWhite,
//             padding: const EdgeInsets.all(0),
//             onPressed: () {
//               if (textEditingController?.text.isNotEmpty == true) {
//                 textEditingController?.text = "";
//                 setState(() {});
//                 if (focusNode?.hasFocus == false) {
//                   //clear marker
//                 }
//                 else {
//                   widget.onTextChanged?.call(textEditingController?.text ?? "");
//                 }
//               }
//               else {
//                 if (focusNode?.hasFocus == false) {
//                   //clear marker
//                   return;
//                 }
//                 UIHelper.hideKeyboard(context);
//               }
//             },
//             color: (focusNode?.hasFocus == true || textEditingController?.text.isNotEmpty == true)
//                 ? ColorConstants.baseBlack
//                 : ColorConstants.grey,
//             icon: const Icon(Icons.close_rounded,),
//           ),
//         ),
//         style: TextStyle(
//           fontSize: DimenConstants.getProportionalScreenWidth(context, 20),
//           color: ColorConstants.baseBlack,
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     focusNode?.removeListener(onFocusChanged);
//     focusNode?.dispose();
//     textEditingController?.dispose();
//     super.dispose();
//   }
// }

// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:go_to/configs/constants/dio_constants.dart';
// import 'package:go_to/configs/constants/enums/location_enums.dart';
// import 'package:go_to/configs/constants/string_constants.dart';
// import 'package:go_to/configs/injection.dart';
// import 'package:go_to/cores/managers/network_manager.dart';
// import 'package:go_to/models/ors_outputs/autocomplete_output.dart';
// import 'package:go_to/views/widgets/icons/location_icons/end_location_icon.dart';
// import 'package:go_to/views/widgets/icons/location_icons/start_location_icon.dart';
// import 'package:latlong2/latlong.dart';
//
// part 'client_home_state.dart';
//
// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(const HomeState());
//
//   final networkManager = injector<NetworkManager>();
//   final dioOpenRouteService = injector<NetworkManager>().getOpenRouteServiceDio();
//
//   FutureOr<Iterable<String>> getSuggestedList(LocationEnums locationEnum, String inputText) async {
//     List<SuggestedLocation> suggestedLocationList = [
//       SuggestedLocation(name: StringConstants.yourLocation, locationEnum: locationEnum),
//     ];
//     if (inputText.isNotEmpty) {
//       print(inputText);
//       final result = await _callORSAutocompleteApi(inputText);
//       print(result.toJson());
//
//       suggestedLocationList = result.features?.map((feature) {
//         double? lat = feature.geometry?.coordinates?[1].toDouble();
//         double? lng = feature.geometry?.coordinates?[0].toDouble();
//         return SuggestedLocation(
//           name: feature.properties?.label,
//           coordinates: (lat != null && lng != null) ? LatLng(lat, lng) : null,
//         );
//       }).toList() ?? [];
//     }
//
//
//
//     if (locationEnum == LocationEnums.startPoint) {
//       emit(state.copyWith(startingPointSuggestions: suggestedLocationList));
//     }
//     else {
//       emit(state.copyWith(endingPointSuggestions: suggestedLocationList));
//     }
//     return suggestedLocationList.map((location) => location.name ?? "");
//   }
//   Future<AutocompleteOutput> _callORSAutocompleteApi(String inputText) async {
//     return AutocompleteOutput.fromJson(await networkManager.request(
//       dioOpenRouteService, RequestMethod.getMethod,
//       "${DioConstants.openRouteServiceBaseUrl}${DioConstants.openRouteServiceActions["autocomplete"]}?",
//       queryParameters: {
//         "api_key": DioConstants.openRouteServiceApiKey, "text": inputText,
//       },
//     ),);
//   }
//
//   void addMarkerListAt(LocationEnums locationEnum, String text) {
//     final tempMarkerList = state.listMarker ?? [];
//     final List<SuggestedLocation>? tempList = locationEnum == LocationEnums.startPoint
//         ? state.startingPointSuggestions : state.endingPointSuggestions;
//     final selectedOption = tempList?.firstWhere(
//             (suggestedLocation) => text.compareTo(suggestedLocation.name ?? "") == 0
//     ) ?? SuggestedLocation();
//
//     locationEnum == LocationEnums.startPoint
//         ? emit(state.copyWith(chosenStartingPoint: selectedOption))
//         : emit(state.copyWith(chosenEndingPoint: selectedOption));
//
//     tempMarkerList.add(
//       Marker(
//         point: selectedOption.coordinates ?? LatLng(0, 0),
//         builder: (BuildContext context) {
//           return locationEnum == LocationEnums.startPoint
//               ? const StartLocationIcon() : const EndLocationIcon();
//         },
//       ),
//     );
//     emit(state.copyWith(listMarker: tempMarkerList));
//   }
//
//   void removeMarkerListAt(LocationEnums locationEnum) {
//     var locationToRemove = locationEnum == LocationEnums.startPoint
//         ? state.chosenStartingPoint : state.chosenEndingPoint;
//
//     if (locationToRemove != null){
//       final tempMarkerList = state.listMarker;
//       tempMarkerList?.removeWhere(
//               (marker) => marker.point == locationToRemove.coordinates
//       );
//       emit(state.copyWith(listMarker: tempMarkerList));
//       locationEnum == LocationEnums.startPoint
//           ? emit(state.copyWith(chosenStartingPoint: null))
//           : emit(state.copyWith(chosenEndingPoint: null));
//     }
//   }
// }


// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_to/configs/constants/dimen_constants.dart';
// import 'package:go_to/configs/constants/enums/location_enums.dart';
// import 'package:go_to/views/pages/main_page/widgets/child_pages/home_page/blocs/client_home_cubit.dart';
// import 'package:go_to/views/widgets/icons/location_icons/end_location_icon.dart';
// import 'package:go_to/views/widgets/icons/location_icons/start_location_icon.dart';
// import 'package:go_to/views/widgets/input_fields/address_input_field/address_autocomplete_text_field.dart';
//
// class AddressInputField extends StatefulWidget {
//   const AddressInputField({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => AddressInputFieldState();
// }
//
// class AddressInputFieldState extends State<AddressInputField> {
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       builder: (contextHome, state) {
//         return Column(
//           children: [
//             _buildChild(
//               context, onTextChanged: (text) => contextHome.read<HomeCubit>().getSuggestedList(
//                 LocationEnums.startPoint, text),
//               onOptionSelected: (text) => contextHome.read<HomeCubit>().addMarkerListAt(
//                   LocationEnums.startPoint, text),
//               icon: const StartLocationIcon(),
//             ),
//             SizedBox(
//               height: DimenConstants.getProportionalScreenHeight(context, 8),),
//
//             _buildChild(
//               context, onTextChanged: (text) => contextHome.read<HomeCubit>().getSuggestedList(
//                 LocationEnums.endPoint, text),
//               onOptionSelected: (text) => contextHome.read<HomeCubit>().addMarkerListAt(
//                   LocationEnums.endPoint, text),
//               icon: const EndLocationIcon(),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildChild(BuildContext context, {
//     required Widget icon,
//     FutureOr<Iterable<String>> Function(String text)? onTextChanged, void Function()? onClearText,
//     required void Function(String text) onOptionSelected,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         //if user is client
//         icon,
//         SizedBox(width: DimenConstants.getProportionalScreenWidth(context, 8),),
//         AddressAutocompleteTextField(
//           onTextChanged: onTextChanged,
//           onOptionSelected: onOptionSelected,
//         ),
//         SizedBox(
//           width: DimenConstants.getProportionalScreenWidth(context, 12),),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
// }


