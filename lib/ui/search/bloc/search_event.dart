part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];

  const SearchEvent();
}

class GetSearchEvent extends SearchEvent {
  final String searchKey;
  @override
  List<Object?> get props => [searchKey];
  const GetSearchEvent({required this.searchKey});
}
