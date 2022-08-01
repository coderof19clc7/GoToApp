part of 'main_cubit.dart';

@immutable
class MainState {
  final int currentIndex;

  const MainState({
    this.currentIndex = 0,
  });

  MainState copyWith({
    int? currentIndex,
  }) {
    return MainState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}