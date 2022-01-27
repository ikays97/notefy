import 'package:flutter/material.dart';
import 'package:morphosis_flutter_demo/data/service/app_service.dart';
import 'package:morphosis_flutter_demo/presentation/screens/index/index.view.dart';
import 'package:morphosis_flutter_demo/presentation/shared/theming.dart';
import 'presentation/shared/routes.dart';
import 'presentation/shared/widgets/app_observer.dart';

const title = 'Morphosis Demo';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppService.instance.startApp();
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: title,
      theme: AppTheme.lightTheme(),
      onGenerateRoute: onGenerateRoutes,
      initialRoute: IndexPage.routeName,
      builder: (context, home) => AppObserver(home!),
    );
  }
}
