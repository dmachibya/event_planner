import 'package:event_planner/models/Ukumbi.dart';
import 'package:event_planner/screens/UkumbiListView.dart';
import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/screens/LoginScreen.dart';
import 'package:event_planner/screens/RegisterScreen.dart';
import 'package:event_planner/screens/landing_screen.dart';
import 'package:event_planner/screens/successful_screen.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../screens/UkumbiDetailScreen.dart';

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
          return const SuccessfulScreen();
        });
      case ukumbiRegisterScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          return UkumbiRegisterScreen();
        });
      case ukumbiDetailScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          Ukumbi ukumbi = settings.arguments as Ukumbi;
          return UkumbiDetailScreen(ukumbi:ukumbi);
        });
      case ukumbiListView:
        return MaterialPageRoute(builder: (BuildContext context) {
          return UkumbiListView();
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
