import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/utils/AppRouter.dart';
import 'package:event_planner/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  AppRouter _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData(primaryColor: Colors.deepOrange),
        routeInformationParser: _router.router.routeInformationParser,
        routerDelegate: _router.router.routerDelegate,
        debugShowCheckedModeBanner: false);
  }
}
