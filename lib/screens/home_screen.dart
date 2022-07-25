import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/components/CustomeDrawer.dart';
import 'package:event_planner/components/banner_carousel.dart';
import 'package:event_planner/components/categories.dart';
import 'package:event_planner/screens/warma_detailScreen.dart';
import 'package:event_planner/screens/WarmaRegisterScreen.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
            child: Text("Categories",
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.pink)),
          ),
          const CategoryContainers(),
          SizedBox(height: 12),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: StreamBuilder<QuerySnapshot>(
                    stream: db.collection("accessories").snapshots(),
                    builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Text("There was a problem"),
                        );
                      }
                      if (!snapshot.hasData) {
                        const Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Text("No data"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Text("Loading..."),
                        );
                      }

                      var items = snapshot.data!.docs;

                      if (items.isEmpty) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to WARMA",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                            ),
                            BannerCarousel(),
                            Text("Currently no data")
                          ],
                        );
                      }

                      return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Welcome to WARMA",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(color: Colors.black),
                                  ),
                                  BannerCarousel(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return UkumbiDetailScreen(
                                            ukumbi: items[index]);
                                      }));
                                    },
                                    child: customCard(items, index, context),
                                  )
                                ],
                              );
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UkumbiDetailScreen(
                                      ukumbi: items[index]);
                                }));
                              },
                              child: customCard(items, index, context),
                            );
                          });
                    }))),
          ),
        ],
      ),
    );
  }

  Card customCard(List<QueryDocumentSnapshot<Object?>> items, int index,
      BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(
              items[index].get("image") != 'null'
                  ? items[index].get("image")
                  : images[0],
              width: double.infinity,
              height: 150,
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
          SizedBox(
            height: 10,
          ),
          Text("Price: "),
          Container(
            child: Text(
              "TZS ${items[index].get('price')}",
              style: TextStyle(fontSize: 12),
            ),
            padding: EdgeInsets.symmetric(vertical: 4),
          ),
          SizedBox(height: 10),
          Text("Category: ${items[index].get('category')}")
        ]),
      ),
    );
  }
}
