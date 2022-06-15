import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/components/CustomeDrawer.dart';
import 'package:event_planner/components/banner_carousel.dart';
import 'package:event_planner/screens/UkumbiDetailScreen.dart';
import 'package:event_planner/screens/UkumbiRegisterScreen.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:flutter/material.dart';

class SuccessfulScreen extends StatelessWidget {
  SuccessfulScreen({Key? key}) : super(key: key);

  final db = FirebaseFirestore.instance;

  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomHomeDrawer(),
      appBar: AppBar(title: Text("Event Reservation")),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection("ukumbi").snapshots(),
              builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Tatizo limejitokeza..."),
                  );
                }
                if (!snapshot.hasData) {
                  const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Hakuna taarifa"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Inapakua..."),
                  );
                }

                var items = snapshot.data!.docs;

                if (items.isEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [BannerCarousel(), Text("Hakuna kumbi kwa sasa")],
                  );
                }

                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BannerCarousel(),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UkumbiDetailScreen(
                                      ukumbi: items[index]);
                                }));
                              },
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.network(
                                            items[index].get("image") != 'null'
                                                ? items[index].get("image")
                                                : images[0],
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
                                            Text("Hali: "),
                                            Container(
                                              child:
                                                  items[index].get('isBooked')
                                                      ? Text(
                                                          "Booked",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      : Text("Available",
                                                          style: TextStyle(
                                                              fontSize: 12)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 8),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey.shade200),
                                            ),
                                            Spacer(),
                                            Text("Aina: "),
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
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Price: "),
                                        Container(
                                          child: Text(
                                            "TZS ${items[index].get('price')}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey.shade200),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ],
                        );
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
                                  Image.network(
                                      items[index].get("image") != "null"
                                          ? items[index].get("image")
                                          : images[0],
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
