import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState(list: [])) {
    on<GetSearchEvent>(_onSelectedCategory);
  }

  List<QueryDocumentSnapshot<Object?>> list = [];

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference shops = FirebaseFirestore.instance.collection('shops');

  void _onSelectedCategory(
    GetSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    list.clear();
    final futureResult = await Future.wait([
      task1(event.searchKey),
      task2(event.searchKey),
      task3(event.searchKey),
    ]);

    for (var taskResult in futureResult) {
      list += taskResult;
    }

    print(list.toSet().toList().length);

    emit(
      state.copyWith(
        list: list.toSet().toList(),
      ),
    );
  }

  Future<List<QueryDocumentSnapshot<Object?>>> task1(String? value) async {
    // Perform asynchronous task 1
    var result = await products
        .orderBy('category')
        .startAt([value]).endAt(['$value\uf8ff']).get();
    return result.docs;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> task2(String? value) async {
    // Perform asynchronous task 1
    var result = await shops
        .orderBy('name')
        .startAt([value]).endAt(['$value\uf8ff']).get();
    return result.docs;
  }

  Future<List<QueryDocumentSnapshot<Object?>>> task3(String? value) async {
    // Perform asynchronous task 1
    var result = await products
        .orderBy('name')
        .startAt([value]).endAt(['$value\uf8ff']).get();
    return result.docs;
  }
}
