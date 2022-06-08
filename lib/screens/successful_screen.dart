import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/components/banner_carousel.dart';
import 'package:event_planner/screens/UkumbiDetailScreen.dart';
import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:flutter/material.dart';

class SuccessfulScreen extends StatelessWidget {
  SuccessfulScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
          leading: Icon(Icons.add),
          title: Text("New Ukumbi"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UkumbiRegisterScreen()));
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
      ])),
      appBar: AppBar(title: Text("Event Reservation")),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection("ukumbi").snapshots(),
              builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("There was an error");
                }
                if (!snapshot.hasData) {
                  Text("No data available");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading...");
                }
                var items = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return BannerCarousel();
                      }
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UkumbiDetailScreen(ukumbi: items[index]);
                          }));
                        },
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(items[index].get("image"),
                                      width: double.infinity,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  SizedBox(height: 10),
                                  Text(
                                    items[index].get('name'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .copyWith(color: Colors.black),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text("Status: "),
                                      Container(
                                        child: items[index].get('isBooked')
                                            ? Text(
                                                "Booked",
                                                style: TextStyle(fontSize: 12),
                                              )
                                            : Text("Available",
                                                style: TextStyle(fontSize: 12)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade200),
                                      ),
                                      Spacer(),
                                      Text("Category: "),
                                      Container(
                                        child: Text(
                                          items[index].get('category'),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade200),
                                      )
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      );
                    });
              }))),
    );
  }
}
