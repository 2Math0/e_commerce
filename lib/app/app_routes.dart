import 'package:dio/dio.dart';
import 'package:e_commerce/data/conncetivity.dart';
import 'package:e_commerce/presentation/screens/bottom_nav_wrapper.dart';
import 'package:e_commerce/presentation/screens/registeration_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/presentation/screens/login_screen.dart';

class AppRoutes {
  static const String authentication = '/authentication';
  static const String register = '/registration';
  static const String navigation = '/nav';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Dio dio = Dio();
    final connectivityService = ConnectivityService(dio);
    switch (settings.name) {
      case navigation:
        return MaterialPageRoute(builder: (_) => const BottomNavWrapper());
      case authentication:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
