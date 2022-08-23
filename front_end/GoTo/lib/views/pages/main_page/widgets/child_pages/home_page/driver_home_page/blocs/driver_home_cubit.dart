
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_to/configs/app_configs.dart';
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
        locationEnum: LocationEnums.endPoint,
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

  @override
  void moveMapView(List<Marker> markerList) {
    final length = markerList.length + 1;
    double averageLat = LocationManager.currentPosition?.latitude ?? 0;
    double averageLng = LocationManager.currentPosition?.longitude ?? 0;
    final zoom = length == 1 ? injector<AppConfig>().mapMaxZoom - 2 : injector<AppConfig>().mapMinZoom;
    for (var marker in markerList) {
      averageLat += marker.point.latitude;
      averageLng += marker.point.longitude;
    }
    averageLat /= length;
    averageLng /= length;
    mapController?.move(LatLng(averageLat, averageLng), zoom);
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
    moveMapView(tempMarkerList);
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
    print(coordinateList);
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

  Future<void> _turnOnAvailable(bool available) async {
    if (available) {
      await databaseRef.ref.child(
        "${FirebaseConstants.databaseChildPath["availableDrivers"]}/${userInfo.id}",
      ).set(injector<AppConfig>().deviceToken);
    }
    else {
      await databaseRef.ref.child(
        "${FirebaseConstants.databaseChildPath["availableDrivers"]}/${userInfo.id}",
      ).remove();
    }
  }

  Future<void> onAcceptBookingOrder() async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["bookingResponse"]}",
    ).set({
      "customerId": state.customerID,
      "keyword": "acceptTrip",
      "driverID": userInfo.id,
      "driverName": userInfo.name,
      "driverPhone": userInfo.phone,
      "time": UIHelper.getTimeStamp(),
    });
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.waitToConfirmAcceptation));
  }

  Future<void> _onAcceptationConfirmed() async {
    await _turnOnAvailable(false);
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.accepted));
  }

  Future<void> onPickUpCustomer() async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["bookingResponse"]}",
    ).set({
      "customerId": state.customerID,
      "keyword": "pickedUp",
      "time": UIHelper.getTimeStamp(),
    });
    emit(state.copyWith(driverBookingStatusEnums: DriverBookingStatusEnums.clientPickedUp));
  }

  Future<void> onFinishTrip() async {
    await databaseRef.ref.child(
      "${FirebaseConstants.databaseChildPath["bookingResponse"]}",
    ).set({
      "customerId": state.customerID,
      "keyword": "finished",
      "time": UIHelper.getTimeStamp(),
    });
    await _turnOnAvailable(true);
    clearBookingInformation();
  }

  void onBookingOrderCanceled(String reason) async {
    String cancelMessage = "${StringConstants.you} ${StringConstants.had.toLowerCase()} "
        "${StringConstants.reject.toLowerCase()}";
    switch(reason) {
      case "clientCancel": {
        cancelMessage = "${StringConstants.customer} ${StringConstants.had.toLowerCase()} "
            "${StringConstants.cancel.toLowerCase()} ${StringConstants.booking.toLowerCase()}";
        await _turnOnAvailable(true);
        break;
      }
      case "tripNotAvailable": {
        cancelMessage = StringConstants.notAvailable;
        break;
      }
    }
    showCancelToast(cancelMessage);
    emit(state.copyWith(
      driverBookingStatusEnums: (reason.compareTo("clientCancel") == 0)
          ? DriverBookingStatusEnums.clientCancel
          : ((reason.compareTo("tripNotAvailable") == 0)
          ? DriverBookingStatusEnums.tripNotAvailable
          : DriverBookingStatusEnums.rejected),
    ));
    clearBookingInformation();
  }

  @override
  void clearBookingInformation() {
    emit(state.copyWith(
      listMarker: [], listPolyline: [],
      driverBookingStatusEnums: DriverBookingStatusEnums.none,
      distance: 0, timeEstimate: 0, customerName: "", customerPhone: "",
      distanceToCustomer: 0, timeEstimateToCustomer: 0,
    ));
    moveMapView([]);
  }

  @override
  void handleBaseOnPayloadAndType(Map<String, dynamic> payload, String type) {
    switch(type) {
      case "clientFound": {
        _onReceivedBookingOrder(payload);
        break;
      }
      case "clientCancel":
      case "tripNotAvailable": {
        onBookingOrderCanceled(type);
        break;
      }
      case "confirmAcceptation": {
        _onAcceptationConfirmed();
        break;
      }
    }
  }
}
