import 'package:flutter/material.dart';
import 'package:lawyers/screens/LoginScreen.dart';
import 'package:lawyers/screens/RegisterScreen.dart';
import 'package:lawyers/screens/landing_screen.dart';
import 'package:lawyers/utils/constants.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case landingRoute:
        return MaterialPageRoute(
            builder: (_) => SplashScreenView(
                  navigateRoute: LandingScreen(),
                  duration: 4000,
                  imageSize: 130,
                  imageSrc: "images/logo.png",
                  backgroundColor: Colors.blue,
                ));

      case registerRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return RegisterScreen();
        });
      case loginRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return LoginScreen();
        });
      case homeRoute:
        return MaterialPageRoute(builder: (BuildContext context) {
          return Container(child: Text("Logged IN"));
        });
      default:
        return MaterialPageRoute(
            builder: (_) => SplashScreenView(
                  navigateRoute: LoginScreen(),
                  duration: 4000,
                  imageSize: 130,
                  imageSrc: "images/logo.png",
                  backgroundColor: Colors.lightBlue,
                ));
    }
  }
}
