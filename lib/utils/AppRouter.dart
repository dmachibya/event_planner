import 'package:flutter/material.dart';
import 'package:lawyers/screens/LoginScreen.dart';
import 'package:lawyers/screens/RegisterScreen.dart';
import 'package:lawyers/screens/landing_screen.dart';
import 'package:lawyers/utils/constants.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
        });
      case registerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return RegisterScreen();
        });
      case landingRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return LandingScreen();
        });
      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Text("Not found"),
            ),
          );
        });
    }
  }
}
