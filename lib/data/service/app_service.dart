import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morphosis_flutter_demo/data/repository/firebase_manager.dart';
import 'package:morphosis_flutter_demo/presentation/blocs/http.bloc.dart';
import 'package:morphosis_flutter_demo/presentation/screens/home/search.bloc.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.bloc.dart';
import 'package:morphosis_flutter_demo/presentation/shared/widgets/error_widget.dart';

import '../../main.dart';

/// [APPSERVICE] IS ENTRANCE OF THE APP
/// IT IS SUPPOSED TO START THE APP WITH REQUIRED CREDENTIALS
class AppService {
  static late HttpRequestBloc httpRequests;

  AppService._setInstance();

  static final AppService instance = AppService._setInstance();

  startApp() {
    IndexBloc indexBloc = IndexBloc();
    httpRequests = HttpRequestBloc();
    SearchBloc searchBloc = SearchBloc();

    // TO CATCH UP MY DEADLINE, I WILL SKIP AUTH SYSTEM.
    // IF I WAS SUPPOSED TO AUTH THE USER,
    // I WOULD CREATE AUTH BLOC, THEN INJECT IT TO THIS APPSERVICE CLASS AND
    // DETERMINE IT'S STATE AND WILL NAVIGATE USER BASED ON IT.
    // E.G: (LOGIN FOR UNAUTHED, OTHERWISE HOME)

    runZonedGuarded(() {
      runApp(
        // REGISTER GLOBAL BLOCS HERE
        MultiBlocProvider(
          providers: [
            BlocProvider<IndexBloc>(create: (_) => indexBloc),
            BlocProvider<HttpRequestBloc>(create: (_) => httpRequests),
            BlocProvider<SearchBloc>(create: (_) => searchBloc),
          ],
          child: FirebaseApp(),
        ),
      );
    }, (error, stackTrace) {
      print('runZonedGuarded: Caught error in my root zone.');
    });
  }
}

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await FirebaseManager.shared.initialise();

    debugPrint("firebase initialized");

    // Pass all uncaught errors to Crashlytics.
    var originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      // Forward to original handler.
      originalOnError!(errorDetails);
    };
  }

  // Define an async function to initialize FlutterFire
  Future<void> initialize() async {
    if (_error) {
      setState(() {
        _error = false;
      });
    }

    try {
      await _initializeFlutterFire();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error || !_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: Scaffold(
          body: _error
              ? ErrorMessage(
                  message: "Problem initialising the app",
                  buttonTitle: "RETRY",
                  onTap: initialize,
                )
              : Container(),
        ),
      );
    }
    return App();
  }
}
