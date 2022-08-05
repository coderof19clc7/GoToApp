part of 'home_cubit.dart';

@immutable
class HomeState {
 const HomeState({
  this.startingPointSuggestions, this.endingPointSuggestions,
  this.mapChosenSuggested = const {},
  this.listMarker = const [], this.listPolyline = const [],
 });

 final List<SuggestedLocation>? startingPointSuggestions;
 final List<SuggestedLocation>? endingPointSuggestions;
 final Map<String, SuggestedLocation>? mapChosenSuggested;
 final List<Marker>? listMarker;
 final List<Polyline>? listPolyline;

 HomeState copyWith({
  List<SuggestedLocation>? startingPointSuggestions,
  List<SuggestedLocation>? endingPointSuggestions,
  Map<String, SuggestedLocation>? mapChosenSuggested,
  List<Marker>? listMarker, List<Polyline>? listPolyline,
 }) {
  return HomeState(
   startingPointSuggestions: startingPointSuggestions ?? this.startingPointSuggestions,
   endingPointSuggestions: endingPointSuggestions ?? this.endingPointSuggestions,
   mapChosenSuggested: mapChosenSuggested ?? this.mapChosenSuggested,
   listMarker: listMarker ?? this.listMarker,
   listPolyline: listPolyline ?? this.listPolyline,
  );
 }
}

SuggestedLocation suggestCommentFromJson(String str) =>
    SuggestedLocation.fromJson(json.decode(str));
String suggestCommentToJson(SuggestedLocation data) =>
    json.encode(data.toJson());
class SuggestedLocation{
 SuggestedLocation({
  this.name, this.coordinates, this.locationEnum
 });

 String? name;
 LatLng? coordinates;
 LocationEnums? locationEnum;

 SuggestedLocation.fromJson(dynamic json) {
  name = json['content'] as String;
  coordinates = json['latLng'] as LatLng;
  locationEnum = json['locationEnum'] as LocationEnums;
 }

 SuggestedLocation copyWith({
  String? name, LatLng? coordinates, LocationEnums? locationEnum
 }) => SuggestedLocation(
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
