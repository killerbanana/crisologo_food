part of 'product_bloc.dart';

@immutable
class ProductState extends Equatable {
  final String category;
  final List<String> categoryList;
  final bool withError;
  final bool isLoading;
  final FilePickerResult? file;
  @override
  List<Object?> get props => [
        category,
        categoryList,
        withError,
        isLoading,
        file,
      ];

  const ProductState({
    required this.category,
    required this.categoryList,
    required this.withError,
    required this.isLoading,
    this.file,
  });

  ProductState copyWith({
    String? category,
    List<String>? categoryList,
    bool? withError,
    bool? isLoading,
    FilePickerResult? file,
  }) {
    return ProductState(
      category: category ?? this.category,
      categoryList: categoryList ?? this.categoryList,
      withError: withError ?? this.withError,
      isLoading: isLoading ?? this.isLoading,
      file: file ?? this.file,
    );
  }
}
