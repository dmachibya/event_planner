import 'package:flutter/material.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/authentication.dart';

class AdminScreen extends StatefulWidget {
  AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: //users
          Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection("users")
                    .where("role", isEqualTo: 0)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading...");
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Text(
                        "There was an error ${snapshot.error.toString()}");
                  }
                  if (!snapshot.hasData) {
                    return Text("No data found ");
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Text("No data found ");
                  }
                  return ListView.separated(
                      itemBuilder: ((context, index) {
                        // print("data begins");
                        var item = snapshot.data!.docs[index];
                        // print(snapshot.data!.docs.);
                        // print("data ends");
                        return GestureDetector(
                            child: Card(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          item
                                                  .data()
                                                  .toString()
                                                  .contains('name')
                                              ? item.get('name')
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          "Email: ${item.data().toString().contains('email') ? item.get('email') : ''}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                      Text(
                                          "Phone: ${item.data().toString().contains('phone') ? item.get('phone') : ''}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                  Spacer(),
                                  AppPopupMenu(
                                    menuItems: const [
                                      PopupMenuItem(
                                        value: 3,
                                        child: Text('Delete'),
                                      ),
                                    ],
                                    // initialValue: 2,
                                    onSelected: (int value) {
                                      // print("selected");

                                      if (value == 3) {
                                        // print("here inside");
                                        db
                                            .collection("users")
                                            .doc(item.id)
                                            .delete();
                                      }
                                    },
                                    icon: Icon(Icons.more_vert_outlined),
                                  )
                                ]),
                          ),
                        ));
                      }),
                      separatorBuilder: ((context, index) => Divider()),
                      itemCount: snapshot.data!.docs.length);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
