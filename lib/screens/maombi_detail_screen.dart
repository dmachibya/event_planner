import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:flutter/material.dart';

class MaombiDetailScreen extends StatefulWidget {
  final ukumbi;
  MaombiDetailScreen({Key? key, required this.ukumbi}) : super(key: key);

  @override
  State<MaombiDetailScreen> createState() => _MaombiDetailScreenState();
}

class _MaombiDetailScreenState extends State<MaombiDetailScreen> {
  final db = FirebaseFirestore.instance;
  TextEditingController kataaController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Maombi ya Kumbi Yako")),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Taarifa za ukodishaji",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("Jina la Ukumbi"),
                Spacer(),
                Text(
                  widget.ukumbi.get('ukumbi_name'),
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text("Tarehe"),
                Spacer(),
                Text(
                  widget.ukumbi.get('date'),
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Text(
              "Taarifa za Mkodishaji",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.ukumbi.get('user_booked'))
                    .get(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("Inapakua..."),
                    );
                  }
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

                  var item = snapshot.data;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("Jina Kamili"),
                          Spacer(),
                          Text(
                            item!.get('name'),
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text("Namba ya simu"),
                          Spacer(),
                          Text(
                            item.get('phone'),
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text("Barua Pepe"),
                          Spacer(),
                          Text(
                            item.get('email'),
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                    ],
                  );
                }),
            Divider(),
            SizedBox(
              height: 20,
            ),
            SizedBox(height: 4),
            // Text(
            //   "Chukua Hatua",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(
            //     "NB: Kama ulishakubali ukakubali tena hapa, maombi ya awali yote yatakuwa yamekataliwa "),
            FutureBuilder(
                future: db
                    .collection("ukumbi")
                    .doc(widget.ukumbi.get('ukumbi_id'))
                    .get(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("Inapakua..."),
                    );
                  }

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

                  // return Text(snapshot.data!.get('acceptedUser') !=
                  //         AuthenticationHelper().user.uid
                  //     ? 'match'
                  //     : 'diff');

                  return Row(children: [
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.green),
                            onPressed: true
                                ? () async {
                                    //     var acceptedDate = {
                                    //       widget.ukumbi.get('date'):
                                    //           widget.ukumbi.get('user_booked')
                                    //     };
                                    //     List array = [null];
                                    //     if (snapshot.data!.get('acceptedUser') ==
                                    //         null) {
                                    //       array[0] = [acceptedDate];
                                    //     } else {
                                    //       List array =
                                    //           snapshot.data!.get('acceptedUser');
                                    //       array.add(acceptedDate);
                                    //     }
                                    db
                                        .collection("ukumbi")
                                        .doc(widget.ukumbi.get('ukumbi_id'))
                                        .update({
                                      "acceptedUser": null,
                                    }).then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("zoezi limefanikiwa"),
                                      ));
                                    }).onError((error, stackTrace) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("kuna tatizo haijafanikiwa"),
                                      ));
                                    });

                                    QuerySnapshot lists = await db
                                        .collection("bookings")
                                        .where("ukumbi_id",
                                            isEqualTo:
                                                widget.ukumbi.get('ukumbi_id'))
                                        .where("date",
                                            isEqualTo:
                                                widget.ukumbi.get('date'))
                                        .get();

                                    if (lists.docs.isNotEmpty) {
                                      for (var element in lists.docs) {
                                        // print("element");
                                        await db
                                            .collection("bookings")
                                            .doc(element.id)
                                            .update({
                                          "active": false,
                                          "status": -1
                                        });

                                        // print(element);
                                      }
                                    }

                                    db
                                        .collection("bookings")
                                        .doc(widget.ukumbi.id)
                                        .update({"status": 1, "active": true});
                                  }
                                : null,
                            child: Text("Kubali"))),
                    SizedBox(
                      width: 12,
                    ),
                    // Text(snapshot.data!.get('acceptedUser') ==
                    //         widget.ukumbi.get('user_booked')
                    //     ? 'Same'
                    //     : 'Diff'),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () async {
                            var result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text('Sababu ya kukataa'),
                                content: TextFormField(
                                    onTap: () => {},
                                    keyboardType: TextInputType.text,
                                    controller: kataaController,
                                    decoration:
                                        InputDecoration(label: Text("Sababu"))),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );

                            if (result! == false) {
                              return;
                            }
                            db
                                .collection("bookings")
                                .doc(widget.ukumbi.id)
                                .update({
                              "status": -1,
                              "reason_denied": kataaController.text
                            }).then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Zoezi limefanikiwa",
                                    style: TextStyle(fontSize: 16)),
                                duration: Duration(seconds: 5),
                              ));
                              // if(Authen)
                              // if (snapshot.data!.get('acceptedUser') ==
                              //     AuthenticationHelper().user.uid) {
                              //   db
                              //       .collection("ukumbi")
                              //       .doc(widget.ukumbi.get('ukumbi_id'))
                              //       .update({"acceptedUser": null})
                              //       .then((value) {})
                              //       .onError((error, stackTrace) {
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(SnackBar(
                              //           content:
                              //               Text("kuna tatizo haijafanikiwa"),
                              //         ));
                              //       });
                              // }
                            }).onError((error, stackTrace) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("kuna tatizo haijafanikiwa"),
                              ));
                            });
                          },
                          child: Text("Kataa"),
                        ))
                  ]);
                }),
          ]),
        ));
  }
}
