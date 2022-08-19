import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:go_to/configs/constants/network_constants/firebase_constants.dart';
import 'package:go_to/configs/firebase_configs/realtime_database_service.dart';
import 'package:go_to/configs/injection.dart';
import 'package:go_to/cores/managers/network_manager.dart';
import 'package:go_to/models/infos/user_info.dart';
import 'package:latlong2/latlong.dart';

class LocationManager {
  static LocationManager? _instance;
  static Position? currentPosition;
  static Timer? updateFirebaseDebounce;
  static int updateFirebaseDuration = 1;
  static int updateFirebaseMaxDifferentDistance = 100;
  static int differentDistance = 0, bounceDifferentDistance = 10;
  static int distanceFilter = 100;


  static LocationManager getInstance() {
    _instance ??= LocationManager();
    return _instance!;
  }

  static Future<bool> checkPermissionLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (serviceEnabled == false ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  static Future<Position> requestPermissionLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      // return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return Future.error('Location services are disabled.');

        // return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    // await updateLocationToFirebase();

    print('position longitude: ${position.longitude}');
    print('position latitude: ${position.latitude}');
    return position;
  }

  static LocationSettings _getLocationSettings() {
    return LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
    );
  }

  static StreamSubscription<Position> listenToCurrentLocationChanges() {
    return Geolocator.getPositionStream(
      locationSettings: _getLocationSettings(),
    ).listen((Position? position) {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      if (position != currentPosition) {
        updateFirebaseDebounce?.cancel();
        currentPosition = position;
        if (differentDistance % updateFirebaseMaxDifferentDistance == 0) {
          updateLocationToFirebase();
          differentDistance = 0;
        }
        else {
          differentDistance += bounceDifferentDistance;
          updateFirebaseDebounce =
              Timer(Duration(minutes: updateFirebaseDuration), () {
            differentDistance = 0;
            updateLocationToFirebase();
          });
        }
      }
    });
  }

  static Future<void> updateLocationToFirebase() async {
    final user = injector<UserInfo>();
    final locationLatLng = LatLng(currentPosition?.latitude ?? 0, currentPosition?.longitude ?? 0);
    final locationName = await ApiExecutor.callORSGeocodeReverseApi(locationLatLng);
    if (user.type?.toLowerCase().compareTo("Customer".toLowerCase()) != 0) {
      injector<RealtimeDatabaseService>().ref.child(
        FirebaseConstants.databaseChildPath["currentLocationUpdate"] ?? "",
      ).set({
        "id": user.id,
        "phoneNumber": user.phone,
        "currentLocation": {
          "name": locationName,
          "lat": locationLatLng.latitude,
          "lng": locationLatLng.longitude,
        },
      });
    }
  }
}