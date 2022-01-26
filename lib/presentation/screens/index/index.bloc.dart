import 'package:flutter_bloc/flutter_bloc.dart';

class IndexState {
  final int index;

  IndexState({this.index = 0});

  IndexState copyWith({int? index}) {
    return IndexState(index: index ?? this.index);
  }
}

class IndexBloc extends Cubit<IndexState> {
  IndexBloc() : super(IndexState(index: 0));

  void changeIndex(v) => emit(state.copyWith(index: v));
}
