import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:event_planner/screens/successful_screen.dart';
import 'package:flutter/material.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:go_router/go_router.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      DrawerHeader(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(AuthenticationHelper().user.uid)
                .get(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasError) {
                return Text("There was an eror");
              }
              if (!snapshot.hasData) {
                return Text("No Data Available");
              }
              return Container(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(Icons.person, size: 32)),
                    SizedBox(width: 20),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.get('name'),
                              style: Theme.of(context).textTheme.headline5),
                          Text(snapshot.data!.get('email'))
                        ])
                  ]));
            }),
      ),
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
        title: Text("Register Accessory"),
        onTap: () {
          Navigator.of(context).pop();
          GoRouter.of(context).go("/home/ukumbi_register");
        },
      ),
      // ListTile(
      //   leading: Icon(Icons.list),
      //   title: Text("Your Accessories"),
      //   onTap: () {
      //     Navigator.of(context).pop();
      //     GoRouter.of(context).go("/home/kumbi_zako");
      //   },
      // ),
      // ListTile(
      //   leading: Icon(Icons.list),
      //   title: Text("Requested Accessories"),
      //   onTap: () {
      //     Navigator.of(context).pop();
      //     GoRouter.of(context).go("/home/kumbi_ulizokodi");
      //   },
      // ),
      // ListTile(
      //   leading: Icon(Icons.calendar_month),
      //   title: Text("Maombi ya Kukodi"),
      //   onTap: () {
      //     Navigator.of(context).pop();

      //     GoRouter.of(context).go('/home/maombi_kukodi');
      //     // Navigator.push(
      //     //     context,
      //     //     MaterialPageRoute(
      //     //         builder: (context) => UkumbiRegisterScreen()));
      //   },
      // ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Log Out"),
        onTap: () {
          AuthenticationHelper().signOut().then((value) {
            GoRouter.of(context).go("/login");
          });
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => UkumbiRegisterScreen()));
        },
      ),
    ]));
  }
}
