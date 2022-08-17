part of 'client_home_cubit.dart';

@immutable
class ClientHomeState extends HomeState {
 const ClientHomeState({
  super.mapChosenSuggested = const {},
  super.listMarker = const [], super.listPolyline = const [],
  this.clientBookingStatusEnums = ClientBookingStatusEnums.none,
  super.distance = 0, super.timeEstimate = 0,
  this.driverName, this.driverPhone,
 });

 final ClientBookingStatusEnums clientBookingStatusEnums;
 final String? driverName;
 final String? driverPhone;

 @override
  ClientHomeState copyWith({
  Map<String, LocationInfo>? mapChosenSuggested,
  List<Marker>? listMarker, List<Polyline>? listPolyline,
  ClientBookingStatusEnums? clientBookingStatusEnums,
  double? distance, double? timeEstimate,
  String? driverName, String? driverPhone,
 }) {
  return ClientHomeState(
   mapChosenSuggested: mapChosenSuggested ?? this.mapChosenSuggested,
   listMarker: listMarker ?? this.listMarker,
   listPolyline: listPolyline ?? this.listPolyline,
   clientBookingStatusEnums: clientBookingStatusEnums ?? this.clientBookingStatusEnums,
   distance: distance ?? this.distance,
   timeEstimate: timeEstimate ?? this.timeEstimate,
   driverName: driverName ?? this.driverName,
   driverPhone: driverPhone ?? this.driverPhone,
  );
 }
}
