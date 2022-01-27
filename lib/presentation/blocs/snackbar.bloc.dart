import 'package:bloc/bloc.dart';

enum SnackbarType { success, error }

class SnackbarBloc extends Cubit<SnackbarState> {
  SnackbarBloc() : super(SnackbarState(SnackbarStatus.idle));

  showSnackbar(String message, SnackbarType type) =>
      emit(SnackbarState(SnackbarStatus.showing, message: message, type: type));
}

///
/// [STATE]
///

enum SnackbarStatus { idle, showing }

class SnackbarState {
  final SnackbarStatus status;
  final String? message;
  final SnackbarType? type;
  SnackbarState(this.status, {this.message, this.type});
}
