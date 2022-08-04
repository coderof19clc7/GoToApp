import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/dio_constants.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/ors_outputs/autocomplete_output.dart';
import 'package:go_to/views/widgets/icons/location_icons/end_location_icon.dart';
import 'package:go_to/views/widgets/icons/location_icons/start_location_icon.dart';
import 'package:latlong2/latlong.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final networkManager = injector<NetworkManager>();
  final dioOpenRouteService = injector<NetworkManager>().getOpenRouteServiceDio();

  FutureOr<Iterable<SuggestedLocation>> getSuggestedList(LocationEnums locationEnum, String inputText) async {
    List<SuggestedLocation> suggestedLocationList = [
      SuggestedLocation(name: StringConstants.yourLocation, locationEnum: locationEnum),
    ];
    if (inputText.isNotEmpty) {
      print(inputText);
      final result = await _callORSAutocompleteApi(inputText);
      print(result.toJson());

      suggestedLocationList = result.features?.map((feature) {
        double? lat = feature.geometry?.coordinates?[1].toDouble();
        double? lng = feature.geometry?.coordinates?[0].toDouble();
        return SuggestedLocation(
          name: feature.properties?.label,
          coordinates: (lat != null && lng != null) ? LatLng(lat, lng) : null,
        );
      }).toList() ?? [];
    }

    for (var element in suggestedLocationList) {
      print(element.name);
    }

    if (locationEnum == LocationEnums.startPoint) {
      emit(state.copyWith(startingPointSuggestions: suggestedLocationList));
    }
    else {
      emit(state.copyWith(endingPointSuggestions: suggestedLocationList));
    }
    return suggestedLocationList;
  }
  Future<AutocompleteOutput> _callORSAutocompleteApi(String inputText) async {
    return AutocompleteOutput.fromJson(await networkManager.request(
      dioOpenRouteService, RequestMethod.getMethod,
      "${DioConstants.openRouteServiceBaseUrl}${DioConstants.openRouteServiceActions["autocomplete"]}?",
      queryParameters: {
        "api_key": DioConstants.openRouteServiceApiKey, "text": inputText,
      },
    ),);
  }

  void addMarkerListAt(LocationEnums locationEnum, SuggestedLocation text) {
    final tempMarkerList = [...?state.listMarker];
    final List<SuggestedLocation>? tempList = locationEnum == LocationEnums.startPoint
        ? state.startingPointSuggestions : state.endingPointSuggestions;
    final selectedOption = tempList?.firstWhere(
            (suggestedLocation) => text.name?.compareTo(suggestedLocation.name ?? "") == 0
    ) ?? SuggestedLocation();

    locationEnum == LocationEnums.startPoint
        ? emit(state.copyWith(chosenStartingPoint: selectedOption))
        : emit(state.copyWith(chosenEndingPoint: selectedOption));

    tempMarkerList.add(
      Marker(
        point: selectedOption.coordinates ?? LatLng(0, 0),
        builder: (BuildContext context) {
          return locationEnum == LocationEnums.startPoint
              ? const StartLocationIcon() : const EndLocationIcon();
        },
      ),
    );
    emit(state.copyWith(listMarker: tempMarkerList));
  }

  void removeMarkerListAt(LocationEnums locationEnum) {
    var locationToRemove = locationEnum == LocationEnums.startPoint
        ? state.chosenStartingPoint : state.chosenEndingPoint;

    if (locationToRemove != null){
      final tempMarkerList = state.listMarker;
      tempMarkerList?.removeWhere(
              (marker) => marker.point == locationToRemove.coordinates
      );
      emit(state.copyWith(listMarker: tempMarkerList));
      locationEnum == LocationEnums.startPoint
          ? emit(state.copyWith(chosenStartingPoint: null))
          : emit(state.copyWith(chosenEndingPoint: null));
    }
  }
}
