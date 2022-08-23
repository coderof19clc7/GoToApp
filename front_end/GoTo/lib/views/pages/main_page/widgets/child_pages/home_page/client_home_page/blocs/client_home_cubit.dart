import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
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
  TextEditingController? startTextEditingController;
  TextEditingController? endTextEditingController;
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

  @override
  void moveMapView(List<Marker> markerList) {
    if (markerList.isNotEmpty) {
      final length = markerList.length;
      double averageLat = 0, averageLng = 0;
      final zoom = length == 1 ? injector<AppConfig>().mapMaxZoom - 2 : injector<AppConfig>().mapMinZoom;
      for (var marker in markerList) {
        averageLat += marker.point.latitude;
        averageLng += marker.point.longitude;
      }
      averageLat /= length;
      averageLng /= length;
      mapController?.move(LatLng(averageLat, averageLng), zoom);
    }
  }

  Future<void> addMarker(LocationInfo selectedSuggestedLocation) async {
    if (selectedSuggestedLocation.name?.toLowerCase()
        .compareTo(StringConstants.yourLocation.toLowerCase()) == 0) {
      //get information of current location
      final tempCoordinate = await getCurrentLocation();
      String tempName = await ApiExecutor.callORSGeocodeReverseApi(tempCoordinate);
      tempName = "${StringConstants.yourLocation}-$tempName";
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

    moveMapView(tempMarkerList);

    if (tempMarkerList.length >= 2) {
      if (willDrawPolyline) {
        prePolylineList.clear();
        await drawPolylineRoute();
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

    moveMapView(tempMarkerList);
  }

  @override
  Future<void> drawPolylineRoute() async {
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
    final startPointName = state.mapChosenSuggested?["startPoint"]?.name ?? "";
    final endPointName = state.mapChosenSuggested?["endPoint"]?.name ?? "";

    await injector<RealtimeDatabaseService>().ref.child(
      "${FirebaseConstants.databaseChildPath["booking"]}"
    ).set({
      "id": injector<UserInfo>().id,
      "phoneNumber": injector<UserInfo>().phone,
      "time": UIHelper.getTimeStamp(),
      "startPoint": {
        "name": startPointName.contains(StringConstants.yourLocation)
            ? startPointName.split("${StringConstants.yourLocation}-")[1] : startPointName,
        "lat": state.mapChosenSuggested?["startPoint"]?.coordinates?.latitude,
        "lng": state.mapChosenSuggested?["startPoint"]?.coordinates?.longitude,
      },
      "endPoint": {
        "name": endPointName.contains(StringConstants.yourLocation)
            ? endPointName.split("${StringConstants.yourLocation}-")[1] : endPointName,
        "lat": state.mapChosenSuggested?["endPoint"]?.coordinates?.latitude,
        "lng": state.mapChosenSuggested?["endPoint"]?.coordinates?.longitude,
      },
    }).then((value) => emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.finding)));
  }

  Future<void> canceling() async {
    await injector<RealtimeDatabaseService>().ref.child(
        "${FirebaseConstants.databaseChildPath["bookingStatus"]}"
    ).set({
      "customerId": injector<UserInfo>().id,
      "keyword": "cancel",
      "time": UIHelper.getTimeStamp(),
    }).then((value) => emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.showBookingInfo)));
  }

  void _onDriverFound(Map<String, dynamic> payload) {
    emit(state.copyWith(
      driverName: payload["driverName"] ?? "",
      driverPhone: payload["driverPhone"] ?? "",
      clientBookingStatusEnums: ClientBookingStatusEnums.driverFound,
    ));
  }

  @override
  void clearBookingInformation() {
    startTextEditingController?.text = "";
    endTextEditingController?.text = "";
    prePolylineList.clear();
    state.listMarker?.clear();
    state.listPolyline?.clear();
    emit(state.copyWith(
      listMarker: [], listPolyline: [],
      clientBookingStatusEnums: ClientBookingStatusEnums.none,
      distance: 0, timeEstimate: 0, driverName: "", driverPhone: "",
    ));
  }

  @override
  void handleBaseOnPayloadAndType(Map<String, dynamic> payload, String type) {
    switch(type) {
      case "driverFound": {
        _onDriverFound(payload);
        break;
      }
      case "driverArrived": {
        if (state.clientBookingStatusEnums == ClientBookingStatusEnums.driverFound) {
          emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.driverArrived));
        }
        break;
      }
      case "tripFinished": {
        if (state.clientBookingStatusEnums == ClientBookingStatusEnums.driverArrived) {
          emit(state.copyWith(clientBookingStatusEnums: ClientBookingStatusEnums.finished));
        }
        break;
      }
    }
  }
}
