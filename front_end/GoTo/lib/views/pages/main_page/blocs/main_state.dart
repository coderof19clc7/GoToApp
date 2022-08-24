part of 'main_cubit.dart';

@immutable
class MainState {
  final int currentIndex;
  final int tempVal;

  const MainState({
    this.currentIndex = 0,
    this.tempVal = 1,
  });

  MainState copyWith({
    int? currentIndex, int? tempVal
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
      tempVal: tempVal ?? this.tempVal,
    );
  }
}