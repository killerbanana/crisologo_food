part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];

  const ProductEvent();
}

class SelectCategoryEvent extends ProductEvent {
  final String category;
  @override
  List<Object?> get props => [category];

  const SelectCategoryEvent({
    required this.category,
  });
}

class GetCategoryEvent extends ProductEvent {
  @override
  List<Object?> get props => [];
  const GetCategoryEvent();
}

class AddErrorEvent extends ProductEvent {
  final bool withError;
  @override
  List<Object?> get props => [withError];
  const AddErrorEvent({required this.withError});
}

class LoadingEvent extends ProductEvent {
  final bool loading;
  @override
  List<Object?> get props => [loading];
  const LoadingEvent({required this.loading});
}

class ChangeProductImageEvent extends ProductEvent {
  final FilePickerResult? file;
  @override
  List<Object> get props => [];
  const ChangeProductImageEvent({
    required this.file,
  });
}
