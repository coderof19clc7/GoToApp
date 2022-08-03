part of 'home_cubit.dart';

@immutable
class HomeState {
 const HomeState({
  this.startingPointSuggestions, this.endingPointSuggestions,
  this.listMarker = const [],
 });

 final List<String>? startingPointSuggestions;
 final List<String>? endingPointSuggestions;
 final List<Marker>? listMarker;

 HomeState copyWith({
  List<String>? startingPointSuggestions,
  List<String>? endingPointSuggestions,
  List<Marker>? listMarker,
 }) {
  return HomeState(
   startingPointSuggestions: startingPointSuggestions ?? this.startingPointSuggestions,
   endingPointSuggestions: endingPointSuggestions ?? this.endingPointSuggestions,
   listMarker: listMarker ?? this.listMarker,
  );
 }
}
