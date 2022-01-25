import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/presentation/blocs/http.bloc.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.bloc.dart';

import '../../main.dart';

/// [APPSERVICE] IS ENTRANCE OF THE APP
/// IT IS SUPPOSED TO START THE APP WITH REQUIRED CREDENTIALS
class AppService {
  static HttpRequestBloc httpRequests;

  AppService._setInstance();

  static final AppService instance = AppService._setInstance();

  startApp() {
    IndexBloc indexBloc = IndexBloc();
    httpRequests = HttpRequestBloc();

    // TO CATCH UP MY DEADLINE, I WILL SKIP AUTH SYSTEM.
    // IF I WAS SUPPOSED TO AUTH THE USER,
    // I WOULD CREATE AUTH BLOC, THEN INJECT IT TO THIS APPSERVICE CLASS AND
    // DETERMINE IT'S STATE AND WILL NAVIGATE USER BASED ON IT.
    // E.G: (LOGIN FOR UNAUTHED, OTHERWISE HOME)

    runZonedGuarded(() {
      runApp(
        // REGISTER GLOBAL BLOCS HERE
        MultiBlocProvider(providers: [
          BlocProvider(create: (_) => indexBloc),
        ], child: FirebaseApp()),
      );
    }, (error, stackTrace) {
      print('runZonedGuarded: Caught error in my root zone.');
    });
  }
}
