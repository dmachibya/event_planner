import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:event_planner/screens/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:event_planner/utils/authentication.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      DrawerHeader(
          child: Container(
              width: double.infinity,
              height: 40,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(100),
              //     color: Colors.grey),
              child: Icon(Icons.person))),
      ListTile(
        leading: Icon(Icons.home),
        title: Text("Home"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SuccessfulScreen()));
        },
      ),
      ListTile(
        leading: Icon(Icons.add),
        title: Text("New Ukumbi"),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UkumbiRegisterScreen()));
        },
      ),
      ListTile(
        leading: Icon(Icons.calendar_month),
        title: Text("Bookings"),
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => UkumbiRegisterScreen()));
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Log Out"),
        onTap: () {
          AuthenticationHelper().signOut();
          Navigator.pushNamed(context, loginRoute);
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => UkumbiRegisterScreen()));
        },
      ),
    ]));
  }
}
