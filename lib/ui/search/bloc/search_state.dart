part of 'search_bloc.dart';

@immutable
class SearchState extends Equatable {
  final List<QueryDocumentSnapshot<Object?>> list;
  @override
  List<Object?> get props => [
        list,
      ];

  const SearchState({
    required this.list,
  });

  SearchState copyWith({
    List<QueryDocumentSnapshot<Object?>>? list,
  }) {
    return SearchState(
      list: list ?? this.list,
    );
  }
}
