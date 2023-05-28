part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];

  const HomeEvent();
}

class SelectIndexEvent extends HomeEvent {
  final int index;
  @override
  List<Object?> get props => [index];

  const SelectIndexEvent({
    required this.index,
  });
}
