import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/network_constants/dio_constants.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/configs/constants/keys/map_keys.dart';
import 'package:go_to/configs/constants/network_constants/open_route_service_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/ors_outputs/autocomplete_output.dart';
import 'package:go_to/models/ors_outputs/direction_output.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:latlong2/latlong.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final networkManager = injector<NetworkManager>();
  final dioOpenRouteService = injector<NetworkManager>().getOpenRouteServiceDio();

  FutureOr<Iterable<SuggestedLocation>> getSuggestedList(LocationEnums locationEnum, String inputText) async {
    //prepare variable
    List<SuggestedLocation> suggestedLocationList = [
      SuggestedLocation(name: StringConstants.yourLocation, locationEnum: locationEnum),
    ];

    //fetch api if user inputs somethings
    if (inputText.isNotEmpty) {
      //fetching api
      print(inputText);
      final result = await _callORSAutocompleteApi(inputText);
      print(result.toJson());

      //convert response to list suggested locations
      suggestedLocationList = result.features?.map((feature) {
        double? lat = feature.geometry?.coordinates?[1].toDouble();
        double? lng = feature.geometry?.coordinates?[0].toDouble();
        return SuggestedLocation(
          name: feature.properties?.label,
          coordinates: (lat != null && lng != null) ? LatLng(lat, lng) : null,
          locationEnum: locationEnum,
        );
      }).toList() ?? [];
    }

    for (var element in suggestedLocationList) {
      print(element.name);
    }

    // if (locationEnum == LocationEnums.startPoint) {
    //   emit(state.copyWith(startingPointSuggestions: suggestedLocationList));
    // }
    // else {
    //   emit(state.copyWith(endingPointSuggestions: suggestedLocationList));
    // }
    return suggestedLocationList;
  }
  Future<AutocompleteOutput> _callORSAutocompleteApi(String inputText) async {
    return AutocompleteOutput.fromJson(await networkManager.request(
      dioOpenRouteService, RequestMethod.getMethod,
      "${DioConstants.openRouteServiceApiPaths["autocompletePath"]}",
      queryParameters: {
        "api_key": OpenRouteServiceConstants.apiKey, "text": inputText,
      },
    ),);
  }

  void addMarkerListAt(SuggestedLocation selectedSuggestedLocation) {
    // final List<SuggestedLocation>? tempList = locationEnum == LocationEnums.startPoint
    //     ? state.startingPointSuggestions : state.endingPointSuggestions;
    // final selectedOption = tempList?.firstWhere(
    //   (suggestedLocation) => selectedSuggestedLocation.name?.compareTo(suggestedLocation.name ?? "") == 0
    // ) ?? SuggestedLocation();

    // locationEnum == LocationEnums.startPoint
    //     ? emit(state.copyWith(chosenStartingPoint: selectedSuggestedLocation))
    //     : emit(state.copyWith(chosenEndingPoint: selectedSuggestedLocation));

    //prepare variable
    final keyToAdd = selectedSuggestedLocation.locationEnum == LocationEnums.startPoint
        ? MapKeys.startPoint : MapKeys.endPoint;
    final tempSuggestedMap = Map<String, SuggestedLocation>.from(state.mapChosenSuggested ?? {});
    final tempMarkerList = [...?state.listMarker];
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');

    //add to or update listMarker
    if (!tempSuggestedMap.containsKey(keyToAdd)) {
      tempMarkerList.add(
        UIHelper.buildMarker(selectedSuggestedLocation),
      );
    }
    else {
      final index = tempMarkerList.indexWhere(
        (marker) => marker.point == tempSuggestedMap[keyToAdd]?.coordinates
      );
      if (index > -1) {
        tempMarkerList[index] = UIHelper.buildMarker(selectedSuggestedLocation);
      }
      else {
        tempMarkerList.add(UIHelper.buildMarker(selectedSuggestedLocation));
      }
    }
    //add to or update mapChosenSuggested
    tempSuggestedMap.addEntries({
      (selectedSuggestedLocation.locationEnum == LocationEnums.startPoint
          ? MapKeys.startPoint
          : MapKeys.endPoint): selectedSuggestedLocation
    }.entries);

    emit(state.copyWith(mapChosenSuggested: tempSuggestedMap, listMarker: tempMarkerList));
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');

    if (tempMarkerList.length >= 2 && state.listPolyline?.isEmpty == true) {
      _drawPolylineRoute();
    }
  }

  void removeMarkerListAt(LocationEnums locationEnum) {
    // final locationToRemove = locationEnum == LocationEnums.startPoint
    //     ? (state.mapChosenSuggested?['startPoint']) : (state.mapChosenSuggested?['endPoint']);
    //
    // if (locationToRemove != null){
    //   final tempMarkerList = [...?state.listMarker];
    //   tempMarkerList.removeWhere(
    //     (marker) => marker.point == locationToRemove.coordinates
    //   );
    //   emit(state.copyWith(listMarker: tempMarkerList));
    //   locationEnum == LocationEnums.startPoint
    //       ? emit(state.copyWith(chosenStartingPoint: null))
    //       : emit(state.copyWith(chosenEndingPoint: null));
    // }

    //prepare variable
    final keyToRemove = locationEnum == LocationEnums.startPoint ? MapKeys.startPoint : MapKeys.endPoint;
    final tempSuggestedMap = Map<String, SuggestedLocation>.from(state.mapChosenSuggested ?? {});
    final tempMarkerList = [...?state.listMarker];
    final tempPolylineList = [...?state.listPolyline];
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');

    tempMarkerList.removeWhere(
      (marker) {
        print('OK here');
        print('marker: ${marker.point}');
        print('chosenKey: ${tempSuggestedMap[keyToRemove]?.coordinates ?? "null"}');
      final willRemoveSth = marker.point == tempSuggestedMap[keyToRemove]?.coordinates;
        if (willRemoveSth) {
          print('OK will remove');
          tempSuggestedMap.remove(keyToRemove);
          tempPolylineList.clear();
        }
        return willRemoveSth;
      }
    );
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');
    emit(state.copyWith(
      listMarker: tempMarkerList, mapChosenSuggested: tempSuggestedMap,
      listPolyline: tempPolylineList,
    ));
  }

  Future<void> _drawPolylineRoute() async {
    final response = await _callORSDirectionApi();
    print(response.toJson());

    final polylineDataList = response.features?.map((feature) {
      final geometry = feature.geometry;
      return geometry?.coordinates?.map(
        (coordinate) => LatLng(coordinate[1].toDouble(), coordinate[0].toDouble())
      ).toList();
    }).toList() ?? [];
    if (polylineDataList.isNotEmpty) {
      List<Polyline> tempPolylineList = [];
      for (var polylineData in polylineDataList) {
        if (polylineData?.isNotEmpty == true) {
          tempPolylineList.add(UIHelper.buildPolyline(polylineData!));
        }
      }
      emit(state.copyWith(listPolyline: tempPolylineList));
    }
  }
  Future<DirectionOutput> _callORSDirectionApi() async {
    final startPointCoorString = state.mapChosenSuggested?[MapKeys.startPoint]?.coordinates ?? LatLng(0, 0);
    final endPointCoorString = state.mapChosenSuggested?[MapKeys.endPoint]?.coordinates ?? LatLng(0, 0);
    final coordinateData =
        [[startPointCoorString.longitude,startPointCoorString.latitude],
        [endPointCoorString.longitude,endPointCoorString.latitude]];
    return DirectionOutput.fromJson(await networkManager.request(
      dioOpenRouteService, RequestMethod.postMethod,
      "${DioConstants.openRouteServiceApiPaths["directionPath"]}",
      headers: {
        "Authorization": OpenRouteServiceConstants.apiKey,
        "Content-type": "application/json; charset=utf-8",
      },
      data: {"coordinates": coordinateData},
    ),);
  }
}
