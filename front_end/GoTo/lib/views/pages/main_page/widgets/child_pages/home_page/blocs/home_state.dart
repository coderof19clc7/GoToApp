part of 'home_cubit.dart';

@immutable
class HomeState {
 const HomeState({
  this.startingPointSuggestions, this.endingPointSuggestions,
  this.listMarker = const [],
  this.chosenStartingPoint, this.chosenEndingPoint,
 });

 final List<SuggestedLocation>? startingPointSuggestions;
 final List<SuggestedLocation>? endingPointSuggestions;
 final SuggestedLocation? chosenStartingPoint;
 final SuggestedLocation? chosenEndingPoint;
 final List<Marker>? listMarker;

 HomeState copyWith({
  List<SuggestedLocation>? startingPointSuggestions,
  List<SuggestedLocation>? endingPointSuggestions,
  List<Marker>? listMarker,
  SuggestedLocation? chosenStartingPoint,
  SuggestedLocation? chosenEndingPoint,
 }) {
  return HomeState(
   startingPointSuggestions: startingPointSuggestions ?? this.startingPointSuggestions,
   endingPointSuggestions: endingPointSuggestions ?? this.endingPointSuggestions,
   listMarker: listMarker ?? this.listMarker,
   chosenStartingPoint: chosenStartingPoint,
   chosenEndingPoint: chosenEndingPoint,
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
