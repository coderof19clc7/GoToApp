import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/configs/constants/keys/map_keys.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/home_bloc/home_cubit.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/infos/location_info.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:latlong2/latlong.dart';

part 'client_home_state.dart';

class ClientHomeCubit extends HomeCubit<ClientHomeState> {
  ClientHomeCubit() : super(state: const ClientHomeState());

  final networkManager = injector<NetworkManager>();
  List<Polyline> prePolylineList = [];

  FutureOr<Iterable<LocationInfo>> getSuggestedList(LocationEnums locationEnum, String inputText) async {
    //prepare variable
    List<LocationInfo> suggestedLocationList = [
      LocationInfo(name: StringConstants.yourLocation, locationEnum: locationEnum),
    ];

    //fetch api if user inputs somethings
    if (inputText.isNotEmpty) {
      //fetching api
      print(inputText);
      final result = await ApiExecutor.callORSAutocompleteApi(inputText);
      print(result.toJson());

      //convert response to list suggested locations
      suggestedLocationList = result.features?.map((feature) {
        double? lat = feature.geometry?.coordinates?[1].toDouble();
        double? lng = feature.geometry?.coordinates?[0].toDouble();
        return LocationInfo(
          name: feature.properties?.label,
          coordinates: (lat != null && lng != null) ? LatLng(lat, lng) : null,
          locationEnum: locationEnum,
        );
      }).toList() ?? [];
    }

    for (var element in suggestedLocationList) {
      print(element.name);
    }

    return suggestedLocationList;
  }

  Future<void> addMarker(LocationInfo selectedSuggestedLocation) async {
    if (selectedSuggestedLocation.name?.toLowerCase()
        .compareTo(StringConstants.yourLocation.toLowerCase()) == 0) {
      //get information of current location
      final tempCoordinate = await getCurrentLocation();
      String tempName = "-${await ApiExecutor.callORSGeocodeReverseApi(tempCoordinate)}";
      tempName = "${StringConstants.yourLocation}$tempName";
      selectedSuggestedLocation = LocationInfo(
        name: tempName, coordinates: tempCoordinate,
        locationEnum: selectedSuggestedLocation.locationEnum,
      );
    }

    //prepare variable
    final keyToAdd = selectedSuggestedLocation.locationEnum == LocationEnums.startPoint
        ? MapKeys.startPoint : MapKeys.endPoint;
    final tempSuggestedMap = Map<String, LocationInfo>.from(state.mapChosenSuggested ?? {});
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
    bool willDrawPolyline = true;
    if (tempSuggestedMap[keyToAdd]?.coordinates == selectedSuggestedLocation.coordinates) {
      willDrawPolyline = false;
    }
    tempSuggestedMap.addEntries({
      (selectedSuggestedLocation.locationEnum == LocationEnums.startPoint
          ? MapKeys.startPoint
          : MapKeys.endPoint): selectedSuggestedLocation
    }.entries);

    emit(state.copyWith(mapChosenSuggested: tempSuggestedMap, listMarker: tempMarkerList));
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');

    if (tempMarkerList.length >= 2) {
      if (willDrawPolyline) {
        prePolylineList.clear();
        await _drawPolylineRoute();
      }
      else {
        emit(state.copyWith(listPolyline: prePolylineList));
      }
      emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.showBookingInfo));
    }
  }

  void removeMarker(LocationEnums locationEnum) {
    //prepare variable
    final keyToRemove = locationEnum == LocationEnums.startPoint ? MapKeys.startPoint : MapKeys.endPoint;
    final tempSuggestedMap = Map<String, LocationInfo>.from(state.mapChosenSuggested ?? {});
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
          // tempSuggestedMap.remove(keyToRemove);
          tempPolylineList.clear();
        }
        return willRemoveSth;
      }
    );
    print('map: ${tempSuggestedMap.length}');
    print('list: ${tempMarkerList.length}');
    emit(state.copyWith(
      listMarker: tempMarkerList, mapChosenSuggested: tempSuggestedMap,
      listPolyline: tempPolylineList, clientBookingStatusEnums: ClientBookingStatusEnums.none,
    ));
  }

  Future<void> _drawPolylineRoute() async {
    final startPointCoorString = state.mapChosenSuggested?[MapKeys.startPoint]?.coordinates ?? LatLng(0, 0);
    final endPointCoorString = state.mapChosenSuggested?[MapKeys.endPoint]?.coordinates ?? LatLng(0, 0);
    final coordinateList = [
      [startPointCoorString.longitude, startPointCoorString.latitude],
      [endPointCoorString.longitude, endPointCoorString.latitude]
    ];
    final response = await ApiExecutor.callORSDirectionApi(coordinateList);
    print(response.toJson());

    final feature = response.features?[0];
    if (feature != null) {
      final polylineDataList = feature.geometry?.coordinates?.map((coordinate) {
        return LatLng(coordinate[1].toDouble(), coordinate[0].toDouble());
      }).toList() ?? [];
      if (polylineDataList.isNotEmpty) {
        List<Polyline> tempPolylineList = [];
        tempPolylineList.add(UIHelper.buildPolyline(polylineDataList));
        emit(state.copyWith(
          listPolyline: tempPolylineList,
          distance: (feature.properties?.summary?.distance?.toDouble() ?? 0)/1000,
          timeEstimate: (feature.properties?.summary?.duration?.toDouble() ?? 0)/60,
        ));
        prePolylineList = [...tempPolylineList];
      }
    }
  }

  Future<void> booking() async {
    await injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["booking"]}"
    ).set({
      "phoneNumber": injector<UserInfo>().phone,
      "name": injector<UserInfo>().name,
      "startPoint": {
        "name": state.mapChosenSuggested?["startPoint"]?.name?.split("-")[0],
        "lat": state.mapChosenSuggested?["startPoint"]?.coordinates?.latitude,
        "lng": state.mapChosenSuggested?["startPoint"]?.coordinates?.longitude,
      },
      "endPoint": {
        "name": state.mapChosenSuggested?["endPoint"]?.name?.split("-")[0],
        "lat": state.mapChosenSuggested?["endPoint"]?.coordinates?.latitude,
        "lng": state.mapChosenSuggested?["endPoint"]?.coordinates?.longitude,
      },
    }).then((value) => emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.finding)));
  }

  Future<void> canceling() async {
    await injector<RealtimeDatabaseService>().ref.child(
        "${FirebaseConstants.databaseChildPath["booking"]}"
    ).set({
      "phoneNumber": injector<UserInfo>().phone,
      "message": "cancelBooking",
    }).then((value) => emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.showBookingInfo)));
  }

  @override
  void onReceiveBookingResponse(RemoteMessage? remoteMessage) {
    if (remoteMessage != null) {
      final payload = Map<String, dynamic>.from(json.decode(remoteMessage.data["content"])["payload"]);
      emit(state.copyWith(
        driverName: payload["driverName"] ?? "",
        driverPhone: payload["driverPhone"] ?? "",
        clientBookingStatusEnums: ClientBookingStatusEnums.driverFound,
      ));
    }
  }
}
