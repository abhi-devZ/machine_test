import 'package:flutter/material.dart';
import 'package:machine_test/presentation/pages/login/login_screen.dart';

import 'core/utils/routes/app_routes.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: RouteNameString.root,
      onGenerateRoute: AppRouter().generateRoute,
    );
  }
}
