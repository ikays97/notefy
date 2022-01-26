import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.view.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case IndexPage.routeName:
      return MaterialPageRoute(
        settings: RouteSettings(name: settings.name),
        builder: (context) => IndexPage(),
      );

    /// default
    default:
      return MaterialPageRoute(
        settings: RouteSettings(name: settings.name),
        builder: (context) => IndexPage(),
      );
  }
}
