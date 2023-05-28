import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc()
      : super(const ProductState(
          categoryList: [],
          category: '',
          withError: false,
          isLoading: false,
        )) {
    on<SelectCategoryEvent>(_onSelectedCategory);
    on<GetCategoryEvent>(_loadCategory);
    on<AddErrorEvent>(_addError);
    on<LoadingEvent>(_loading);
    on<ChangeProductImageEvent>(_changeProductImage);
  }

  void _onSelectedCategory(
    SelectCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        category: event.category,
      ),
    );
  }

  void _loadCategory(
    GetCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(),
    );
  }

  void _addError(
    AddErrorEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        withError: event.withError,
      ),
    );
  }

  void _loading(
    LoadingEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        withError: event.loading,
      ),
    );
  }

  _changeProductImage(
      ChangeProductImageEvent event, Emitter<ProductState> emit) async {
    emit(
      state.copyWith(
        file: event.file,
      ),
    );
  }
}
