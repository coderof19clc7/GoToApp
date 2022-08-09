part of 'home_cubit.dart';

class HomeState {
  const HomeState({
    this.mapChosenSuggested = const {},
    this.listMarker = const [], this.listPolyline = const [],
    this.distance = 0, this.timeEstimate = 0,
  });

  final Map<String, LocationInfo>? mapChosenSuggested;
  final List<Marker>? listMarker;
  final List<Polyline>? listPolyline;
  final double distance;
  final double timeEstimate;

  HomeState copyWith({
    Map<String, LocationInfo>? mapChosenSuggested,
    List<Marker>? listMarker, List<Polyline>? listPolyline,
    double? distance, double? timeEstimate,
  }) {
    return HomeState(
      mapChosenSuggested: mapChosenSuggested ?? this.mapChosenSuggested,
      listMarker: listMarker ?? this.listMarker,
      listPolyline: listPolyline ?? this.listPolyline,
      distance: distance ?? this.distance,
      timeEstimate: timeEstimate ?? this.timeEstimate,
    );
  }
}