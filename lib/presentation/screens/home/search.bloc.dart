import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:morphosis_flutter_demo/data/model/post.dart';
import 'package:morphosis_flutter_demo/data/repository/search_repo.dart';
import 'package:morphosis_flutter_demo/data/service/storage_service.dart';

enum SearchStatus { idle, searching, error }

class SearchState {
  SearchStatus status;
  List<Post> results;
  List<String> queries;
  String? error;

  SearchState({
    this.status = SearchStatus.idle,
    this.results = const [],
    this.queries = const [],
    this.error,
  });

  SearchState copyWith({
    SearchStatus? status,
    List<Post>? results,
    List<String>? queries,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      queries: queries ?? this.queries,
      error: error ?? this.error,
    );
  }
}

class SearchBloc extends Cubit<SearchState> {
  SearchBloc() : super(SearchState(status: SearchStatus.idle)) {
    readQueriesCache();
  }

  //
  Future<void> searchPosts(String query) async {
    cacheSearchQuery(query);
    emit(state.copyWith(status: SearchStatus.searching));
    try {
      var response = await SearchRepository.searchPosts(query);
      readQueriesCache();
      emit(state.copyWith(results: response, status: SearchStatus.idle));
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.error, error: _.toString()));
    }
  }

  cacheSearchQuery(String query) async {
    var disk = await LocalStorage.instance;
    var pastSearches = disk.readSearchQueries();
    pastSearches.add(query);
    pastSearches =
        List.castFrom<dynamic, String>(pastSearches.toSet().toList());
    disk.cacheSearchQueries(jsonEncode(pastSearches));
  }

  readQueriesCache() async {
    var pastSearches = (await LocalStorage.instance).readSearchQueries();
    pastSearches =
        List.castFrom<dynamic, String>(pastSearches.toSet().toList());
    emit(state.copyWith(queries: pastSearches));
  }
}
