import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/presentation/blocs/snackbar.bloc.dart';

import '../helpers.dart';

class AppObserver extends StatefulWidget {
  const AppObserver(this.child, {Key? key}) : super(key: key);

  final Widget child;

  @override
  _AppObserverState createState() => _AppObserverState();
}

class _AppObserverState extends State<AppObserver> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    return MultiBlocListener(
      listeners: [
        snackbarListener(),
      ],
      child: MediaQuery(
        data: mq.copyWith(
          textScaleFactor: mq.textScaleFactor > 1.3 ? 1.3 : mq.textScaleFactor,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: widget.child,
        ),
      ),
    );
  }

  snackbarListener() => BlocListener<SnackbarBloc, SnackbarState>(
        listener: (context, SnackbarState state) {
          if (state.type == SnackbarType.success) {
            presentSuccess(state.message!);
          }
          if (state.type == SnackbarType.error) {
            presentError(state.message!);
          }
        },
      );

  presentSuccess(String message) {
    if (message.isEmpty) return;
    showSnackBar(
      context,
      SizedBox(
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.green,
    );
  }

  presentError(String message) {
    if (message.isEmpty) return;
    showSnackBar(
      context,
      Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff323232),
    );
  }
}
