part of 'driver_home_cubit.dart';

@immutable
class DriverHomeState extends HomeState {
  const DriverHomeState({
    super.mapChosenSuggested = const {},
    super.listMarker = const [], super.listPolyline = const [],
    this.driverBookingStatusEnums = DriverBookingStatusEnums.none,
    super.distance = 0, super.timeEstimate = 0,
    this.distanceToCustomer = 0, this.timeEstimateToCustomer = 0,
    this.customerID, this.customerName, this.customerPhone,
  });

  final String? customerID;
  final String? customerName;
  final String? customerPhone;
  final double? distanceToCustomer;
  final double? timeEstimateToCustomer;
  final DriverBookingStatusEnums? driverBookingStatusEnums;

  @override
  DriverHomeState copyWith({
    Map<String, LocationInfo>? mapChosenSuggested,
    List<Marker>? listMarker, List<Polyline>? listPolyline,
    DriverBookingStatusEnums? driverBookingStatusEnums,
    double? distance, double? timeEstimate,
    double? distanceToCustomer, double? timeEstimateToCustomer,
    String? customerID, String? customerName, String? customerPhone,
  }) {
    return DriverHomeState(
      mapChosenSuggested: mapChosenSuggested ?? this.mapChosenSuggested,
      listMarker: listMarker ?? this.listMarker,
      listPolyline: listPolyline ?? this.listPolyline,
      driverBookingStatusEnums: driverBookingStatusEnums ?? this.driverBookingStatusEnums,
      distance: distance ?? this.distance,
      timeEstimate: timeEstimate ?? this.timeEstimate,
      distanceToCustomer: distanceToCustomer ?? this.distanceToCustomer,
      timeEstimateToCustomer: timeEstimateToCustomer ?? this.timeEstimateToCustomer,
      customerID: customerID ?? this.customerID,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
    );
  }
}
