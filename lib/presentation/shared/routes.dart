import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/presentation/screens/home/home.view.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomePage.routeName:
      return MaterialPageRoute(
        settings: RouteSettings(name: settings.name),
        builder: (context) => HomePage(),
      );

    /// default
    default:
      return MaterialPageRoute(
        settings: RouteSettings(name: settings.name),
        builder: (context) => HomePage(),
      );
  }
}
