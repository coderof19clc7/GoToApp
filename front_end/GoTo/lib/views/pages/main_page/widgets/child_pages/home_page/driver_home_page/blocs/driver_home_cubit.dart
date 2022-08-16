import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/constants/enums/booking_status_enums.dart';
import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:go_to/configs/constants/keys/map_keys.dart';
import 'package:go_to/configs/constants/keys/storage_keys.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/constants/string_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/blocs/home_bloc/home_cubit.dart';
import 'package:go_to/cores/managers/local_storage_manager.dart';
import 'package:go_to/cores/managers/location_manager.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/infos/location_info.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:go_to/utilities/helpers/ui_helper.dart';
import 'package:latlong2/latlong.dart';

part 'driver_home_state.dart';

class DriverHomeCubit extends HomeCubit<DriverHomeState> {
  DriverHomeCubit() : super(state: const DriverHomeState());

  final databaseRef = injector<RealtimeDatabaseService>();
  final userInfo = injector<UserInfo>();

  void _onReceivedBookingOrder(Map<String, dynamic> payload) async {
    //get information of show start point and end point and add marker for them
    final startPoint = Map<String, dynamic>.from(payload["startPoint"]);
    final endPoint = Map<String, dynamic>.from(payload["endPoint"]);
    _addMarker(
      LocationInfo(
        name:  startPoint["name"],
        coordinates: LatLng(startPoint["lat"], startPoint["lng"]),
        locationEnum: LocationEnums.startPoint,
      ),
      LocationInfo(
        name:  endPoint["name"],
        coordinates: LatLng(endPoint["lat"], endPoint["lng"]),
        locationEnum: LocationEnums.startPoint,
      ),
    );

    //draw polyline route
    await drawPolylineRoute();

    //change state to show customer information
    emit(state.copyWith(
      customerID: payload["customerId"] ?? "",
      customerName: payload["customerName"] ?? "",
      customerPhone: payload["phoneNumber"] ?? "",
      driverBookingStatusEnums: DriverBookingStatusEnums.clientFound,
    ));
  }

  void _addMarker(LocationInfo startPoint, LocationInfo endPoint) {
    final tempMapChosenSuggested = {
      MapKeys.startPoint: startPoint,
      MapKeys.endPoint: endPoint,
    };
    final tempMarkerList = [
      UIHelper.buildMarker(startPoint),
      UIHelper.buildMarker(endPoint),
    ];
    emit(state.copyWith(
      mapChosenSuggested: tempMapChosenSuggested,
      listMarker: tempMarkerList,
    ));
  }

  @override
  Future<void> drawPolylineRoute() async {
    final startPointCoorString = state.mapChosenSuggested?[MapKeys.startPoint]?.coordinates ?? LatLng(0, 0);
    final endPointCoorString = state.mapChosenSuggested?[MapKeys.endPoint]?.coordinates ?? LatLng(0, 0);
    final coordinateList = [
      [LocationManager.currentPosition?.longitude ?? 0, LocationManager.currentPosition?.latitude ?? 0],
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
          distance: (feature.properties?.segments?[1].distance?.toDouble() ?? 0)/1000,
          timeEstimate: (feature.properties?.segments?[1].duration?.toDouble() ?? 0)/60,
          distanceToCustomer: (feature.properties?.segments?[0].distance?.toDouble() ?? 0)/1000,
          timeEstimateToCustomer: (feature.properties?.segments?[0].duration?.toDouble() ?? 0)/60,
        ));
      }
    }
  }

  Future<void> onAcceptBookingOrder() async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["bookingResponse"]}/${state.customerID}",
    ).set({
      "driverID": userInfo.id,
      "driverName": userInfo.name,
      "driverPhone": userInfo.phone,
    });
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.waitToConfirmAcceptation));
  }

  Future<void> _onAcceptationConfirmed() async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["availableDrivers"]}/${userInfo.id}",
    ).remove();
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.accepted));
  }

  Future<void> onFinishTrip() async {
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.finished));
  }

  void onBookingOrderCanceled(String reason) async {
    final cancelMessage = (reason.compareTo("cancel") == 0)
        ? "${StringConstants.customer} ${StringConstants.had} "
        "${StringConstants.cancel} ${StringConstants.booking}"
        : "${StringConstants.you} ${StringConstants.had} ${StringConstants.reject}";
    showCancelToast(cancelMessage);
    emit(state.copyWith(
      driverBookingStatusEnums: (reason.compareTo("cancel") == 0)
          ? DriverBookingStatusEnums.clientCanceled
          : DriverBookingStatusEnums.rejected,
    ));
    _clearCustomerBookingInformation();

    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["availableDrivers"]}/${userInfo.id}",
    ).set(injector<LocalStorageManager>().getString(LocalStorageKeys.deviceToken));
  }

  void _clearCustomerBookingInformation() {
    state.listMarker?.clear();
    state.listPolyline?.clear();
    emit(state.copyWith(
      listMarker: [], listPolyline: [],
      driverBookingStatusEnums: DriverBookingStatusEnums.none,
      distance: 0, timeEstimate: 0, customerName: "", customerPhone: "",
      distanceToCustomer: 0, timeEstimateToCustomer: 0,
    ));
  }

  @override
  void onReceiveBookingNotification(RemoteMessage? remoteMessage) {
    if (remoteMessage != null) {
      final payload = Map<String, dynamic>.from(json.decode(remoteMessage.data["content"])["payload"]);
      final notificationMessage = payload["type"] ?? "";
      switch(notificationMessage) {
        case "clientFound": {
          _onReceivedBookingOrder(payload);
          break;
        }
        case "cancel": {
          onBookingOrderCanceled("cancel");
          break;
        }
        case "confirmAcceptation": {
          _onAcceptationConfirmed();
          break;
        }
      }
    }
  }
}
