import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(selectedIndex: 0)) {
    on<SelectIndexEvent>(_onSelectedIndex);
  }
  void _onSelectedIndex(
    SelectIndexEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedIndex: event.index,
      ),
    );
  }
}
