part of 'home_bloc.dart';

@immutable
class HomeState extends Equatable {
  int selectedIndex;
  @override
  List<Object?> get props => [selectedIndex];

  HomeState({
    required this.selectedIndex,
  });

  HomeState copyWith({
    int? selectedIndex,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
