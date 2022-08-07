import 'dart:convert';

import 'package:go_to/configs/constants/enums/location_enums.dart';
import 'package:latlong2/latlong.dart';

LocationInfo suggestCommentFromJson(String str) =>
    LocationInfo.fromJson(json.decode(str));
String suggestCommentToJson(LocationInfo data) =>
    json.encode(data.toJson());
class LocationInfo{
  LocationInfo({
    this.name, this.coordinates, this.locationEnum
  });

  String? name;
  LatLng? coordinates;
  LocationEnums? locationEnum;

  LocationInfo.fromJson(dynamic json) {
    name = json['content'] as String;
    coordinates = json['latLng'] as LatLng;
    locationEnum = json['locationEnum'] as LocationEnums;
  }

  LocationInfo copyWith({
    String? name, LatLng? coordinates, LocationEnums? locationEnum
  }) => LocationInfo(
    name: name ?? this.name,
    coordinates: coordinates ?? this.coordinates,
    locationEnum: locationEnum ?? this.locationEnum,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['content'] = name;
    map['latLng'] = coordinates;
    map['locationEnum'] = locationEnum;
    return map;
  }
}
