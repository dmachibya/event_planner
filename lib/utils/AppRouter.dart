import 'package:event_planner/models/Ukumbi.dart';
import 'package:event_planner/screens/UkumbiListView.dart';
import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:event_planner/screens/client_requests.dart';
import 'package:event_planner/screens/kumbi_zako_screen.dart';
import 'package:event_planner/screens/admin_requests.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/screens/LoginScreen.dart';
import 'package:event_planner/screens/RegisterScreen.dart';
import 'package:event_planner/screens/landing_screen.dart';
import 'package:event_planner/screens/successful_screen.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:go_router/go_router.dart';

import '../screens/UkumbiDetailScreen.dart';
import 'authentication.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(
          path: "/login",
          builder: (context, state) {
            return LoginScreen();
          },
          redirect: (_) {
            if (AuthenticationHelper().user != null) {
              return '/home';
            }
            return null;
          },
          routes: [
            GoRoute(
              path: 'register',
              builder: (context, state) {
                return RegisterScreen();
              },
            ),
          ]),
      GoRoute(
          path: '/home',
          builder: (context, state) {
            return SuccessfulScreen();
          },
          redirect: (_) {
            if (AuthenticationHelper().user == null) {
              return '/welcome';
            }
            return null;
          },
          routes: [
            GoRoute(
                path: 'ukumbi_register',
                builder: (context, state) {
                  return UkumbiRegisterScreen();
                },
                routes: []),
            GoRoute(
                path: 'kumbi_zako',
                builder: (context, state) {
                  return KumbiZakoScreen();
                },
                routes: []),
            GoRoute(
                path: 'kumbi_ulizokodi',
                builder: (context, state) {
                  return KumbiUlizoKodiScreen();
                },
                routes: []),
            GoRoute(
                path: 'ukumbi_details/:id',
                builder: (context, state) {
                  final id = state.params['id'];
                  return UkumbiDetailScreen(
                    ukumbi: id,
                  );
                },
                routes: []),
            GoRoute(
              path: 'maombi_kukodi',
              builder: (context, state) {
                final id = state.params['id'];
                return MaombiKukodiScreen();
              },
            ),
          ])
    ],
    // redirect: (state) {
    //   // if the user is not logged in, they need to login
    //   final loggedIn =
    //       AuthenticationHelper().user != null; // check if user is available
    //   final loggingIn = state.subloc == '/welcome/login' ||
    //       state.subloc == '/welcome/register' ||
    //       state.subloc == '/welcome';

    //   print("route");
    //   print(loggingIn);
    //   print(state.subloc);

    //   if (!loggedIn) return loggingIn ? null : '/welcome';

    //   // if the user is logged in but still on the login page, send them to
    //   // the home page
    //   // if(loggedIn)
    //   if (loggingIn) return '/home';
    //   // if (loggedIn) {
    //   //   return '/home/0';
    //   // }else {
    //   //   return
    //   // }

    //   // no need to redirect at all
    //   return null;
    // },
  );
  // static Route<dynamic> generateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case landingRoute:
  //       return MaterialPageRoute(
  //           builder: (_) => SplashScreenView(
  //                 navigateRoute: LandingScreen(),
  //                 duration: 4000,
  //                 imageSize: 130,
  //                 imageSrc: "images/logo.png",
  //                 backgroundColor: Colors.blue,
  //               ));

  //     case registerRoute:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         return RegisterScreen();
  //       });
  //     case loginRoute:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         return LoginScreen();
  //       });
  //     case homeRoute:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         return SuccessfulScreen();
  //       });
  //     case ukumbiRegisterScreen:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         return UkumbiRegisterScreen();
  //       });
  //     case ukumbiDetailScreen:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         Ukumbi ukumbi = settings.arguments as Ukumbi;
  //         return UkumbiDetailScreen(ukumbi: ukumbi);
  //       });
  //     case ukumbiListView:
  //       return MaterialPageRoute(builder: (BuildContext context) {
  //         return UkumbiListView();
  //       });
  //     default:
  //       return MaterialPageRoute(
  //           builder: (_) => SplashScreenView(
  //                 navigateRoute: LoginScreen(),
  //                 duration: 4000,
  //                 imageSize: 130,
  //                 imageSrc: "images/logo.png",
  //                 backgroundColor: Colors.lightBlue,
  //               ));
  //   }
  // }
}
