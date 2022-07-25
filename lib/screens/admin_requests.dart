import 'package:event_planner/screens/warma_detailScreen.dart';
import 'package:event_planner/screens/WarmaRegisterScreen.dart';
import 'package:event_planner/screens/maombi_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:app_popup_menu/app_popup_menu.dart';

import '../utils/authentication.dart';

class MaombiKukodiScreen extends StatefulWidget {
  MaombiKukodiScreen({Key? key}) : super(key: key);

  @override
  State<MaombiKukodiScreen> createState() => _MaombiKukodiScreenState();
}

class _MaombiKukodiScreenState extends State<MaombiKukodiScreen> {
  // final db = FirebaseFire
  final db = FirebaseFirestore.instance;

  // var now = new DateTime.now();
  var today = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    print(today);
    super.initState();
  }
  // String formattedDate = formatter.format(now);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(title: Text("Users requests")),
        body: Container(
          padding:
              EdgeInsets.symmetric(vertical: 20, horizontal: 0.068 * width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: db.collection("rentings").snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...");
                      }
                      if (snapshot.hasError) {
                        return Text("There was an error");
                      }
                      if (!snapshot.hasData) {
                        return Text("There was an error");
                      }
                      if (snapshot.data!.docs.length < 1) {
                        return Text("No data");
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data!.docs[index];
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MaombiDetailScreen(
                                                  ukumbi: item)));
                                },
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                              item
                                                      .data()
                                                      .toString()
                                                      .contains('ukumbi_name')
                                                  ? item.get('ukumbi_name')
                                                  : '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            child: Text(
                                              item.get('status') == 1
                                                  ? 'Accepted'
                                                  : item.get('status') == 0
                                                      ? 'pending'
                                                      : 'Rejected',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: item.get('status') == 1
                                                    ? Colors.green.shade200
                                                    : item.get('status') == -1
                                                        ? Colors.red.shade200
                                                        : Colors.grey),
                                          ),
                                          Spacer(),
                                          AppPopupMenu(
                                            menuItems: const [
                                              PopupMenuItem(
                                                value: 2,
                                                child: Text('View'),
                                              ),
                                              PopupMenuItem(
                                                value: 3,
                                                child: Text('Delete'),
                                              ),
                                            ],
                                            // initialValue: 2,
                                            onSelected: (int value) {
                                              // print("selected");
                                              // print(item.id);
                                              if (value == 2) {
                                                // Navigator
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MaombiDetailScreen(
                                                                ukumbi: item)));
                                              } else if (value == 3) {
                                                print("here inside ${item.id}");
                                                db
                                                    .collection("rentings")
                                                    .doc(item.id)
                                                    .delete();
                                              }
                                            },
                                            icon:
                                                Icon(Icons.more_vert_outlined),
                                          )
                                        ]),
                                      ],
                                    ),
                                  ),
                                ));
                          });
                    }),
              )
            ],
          ),
        ));
  }
}
