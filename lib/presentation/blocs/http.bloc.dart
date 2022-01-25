import 'package:bloc/bloc.dart';

class HttpRequestState {
  /// CONTAINS EVERY SINGLE REQUESTS
  /// OCCURING IN THE APP. USED TO CONTROL FAILS/SUCCESS
  final List<String> requests;

  HttpRequestState(this.requests);
}

class HttpRequestBloc extends Cubit<HttpRequestState> {
  HttpRequestBloc() : super(HttpRequestState([]));

  add(String uri) {
    emit(HttpRequestState([uri, ...state.requests]));
  }

  remove(String uri) {
    emit(HttpRequestState(state.requests.where((r) => r != uri).toList()));
  }

  clear() {
    emit(HttpRequestState([]));
  }
}
