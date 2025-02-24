import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/presentation/pages/home/home_screen.dart';
import 'package:machine_test/presentation/pages/login/login_screen.dart';

part 'route_name_string.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNameString.root:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case RouteNameString.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      // case RouteNameString.pin:
      //   return MaterialPageRoute(
      //     builder: (_) => const PinAuthScreen(),
      //   );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
