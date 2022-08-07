part of 'home_cubit.dart';

@immutable
class HomeState {
 const HomeState({
  this.mapChosenSuggested = const {},
  this.listMarker = const [], this.listPolyline = const [],
  this.clientBookingStatusEnums = ClientBookingStatusEnums.none,
  this.distance = 0, this.timeEstimate = 0,
 });

 final Map<String, LocationInfo>? mapChosenSuggested;
 final List<Marker>? listMarker;
 final List<Polyline>? listPolyline;
 final ClientBookingStatusEnums? clientBookingStatusEnums;
 final double distance;
 final double timeEstimate;

 HomeState copyWith({
  Map<String, LocationInfo>? mapChosenSuggested,
  List<Marker>? listMarker, List<Polyline>? listPolyline,
  ClientBookingStatusEnums? clientBookingStatusEnums,
  double? distance, double? timeEstimate,
 }) {
  return HomeState(
   mapChosenSuggested: mapChosenSuggested ?? this.mapChosenSuggested,
   listMarker: listMarker ?? this.listMarker,
   listPolyline: listPolyline ?? this.listPolyline,
   clientBookingStatusEnums: clientBookingStatusEnums ?? this.clientBookingStatusEnums,
   distance: distance ?? this.distance,
   timeEstimate: timeEstimate ?? this.timeEstimate,
  );
 }
}
