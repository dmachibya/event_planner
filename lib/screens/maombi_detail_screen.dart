import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

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
        appBar: AppBar(title: Text("Request details")),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Request information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("Accessory name"),
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
                Text("Date"),
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
              "Renter information",
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
                      child: Text("Loading..."),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("There was an error..."),
                    );
                  }
                  if (!snapshot.hasData) {
                    const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("No data found"),
                    );
                  }

                  var item = snapshot.data;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text("Full name"),
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
                          Text("Phone number"),
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
                          Text("Email Address"),
                          Spacer(),
                          Text(
                            item.get('email'),
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(height: 4),
                      FutureBuilder(
                          future: db
                              .collection("accessories")
                              .doc(widget.ukumbi.get('ukumbi_id'))
                              .get(),
                          builder: (context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.all(28.0),
                                child: Text("Loading..."),
                              );
                            }

                            if (snap.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(28.0),
                                child: Text("There was a problem..."),
                              );
                            }
                            if (!snap.hasData) {
                              const Padding(
                                padding: EdgeInsets.all(28.0),
                                child: Text("No data"),
                              );
                            }

                            // return Text(snap.data!.get('acceptedUser') !=
                            //         AuthenticationHelper().user.uid
                            //     ? 'match'
                            //     : 'diff');

                            return Row(children: [
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: true
                                          ? () async {
                                              //     var acceptedDate = {
                                              //       widget.ukumbi.get('date'):
                                              //           widget.ukumbi.get('user_booked')
                                              //     };
                                              //     List array = [null];
                                              //     if (snap.data!.get('acceptedUser') ==
                                              //         null) {
                                              //       array[0] = [acceptedDate];
                                              //     } else {
                                              //       List array =
                                              //           snap.data!.get('acceptedUser');
                                              //       array.add(acceptedDate);
                                              //     }
                                              db
                                                  .collection("accessories")
                                                  .doc(widget.ukumbi
                                                      .get('ukumbi_id'))
                                                  .update({
                                                "acceptedUser": null,
                                              }).then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("successfully"),
                                                ));
                                              }).onError((error, stackTrace) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "There was a problem"),
                                                ));
                                              });

                                              QuerySnapshot lists = await db
                                                  .collection("rentings")
                                                  .where("ukumbi_id",
                                                      isEqualTo: widget.ukumbi
                                                          .get('ukumbi_id'))
                                                  .where("date",
                                                      isEqualTo: widget.ukumbi
                                                          .get('date'))
                                                  .get();

                                              if (lists.docs.isNotEmpty) {
                                                for (var element
                                                    in lists.docs) {
                                                  // print("element");
                                                  await db
                                                      .collection("rentings")
                                                      .doc(element.id)
                                                      .update({
                                                    "active": false,
                                                    "status": -1
                                                  });

                                                  // print(element);
                                                }
                                              }

                                              db
                                                  .collection("rentings")
                                                  .doc(widget.ukumbi.id)
                                                  .update({
                                                "status": 1,
                                                "active": true
                                              });

                                              TwilioFlutter twilioFlutter =
                                                  TwilioFlutter(
                                                      accountSid:
                                                          'AC654dd3a61b0d9fd1826ac251752995cb', // replace *** with Account SID
                                                      authToken:
                                                          'd94431e5df6dac77262a2f007e0d934f', // replace xxx with Auth Token
                                                      twilioNumber:
                                                          '+18573746722' // replace .... with Twilio Number
                                                      );

                                              twilioFlutter
                                                  .sendSMS(
                                                      toNumber:
                                                          item.get('phone'),
                                                      messageBody:
                                                          '\n Ombi lako katika WARMA limekubaliwa, wasiliana na Admin kupitia +255 766 727 133')
                                                  .then((value) {})
                                                  .catchError((val) {
                                                print(val);
                                              });
                                            }
                                          : null,
                                      child: Text("Accept"))),
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
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () async {
                                      var result = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text('Reason'),
                                          content: TextFormField(
                                              onTap: () => {},
                                              keyboardType: TextInputType.text,
                                              controller: kataaController,
                                              decoration: InputDecoration(
                                                  label: Text("why"))),
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
                                          .collection("rentings")
                                          .doc(widget.ukumbi.id)
                                          .update({
                                        "status": -1,
                                        "reason_denied": kataaController.text
                                      }).then((value) {
                                        TwilioFlutter twilioFlutter =
                                            TwilioFlutter(
                                                accountSid:
                                                    'AC654dd3a61b0d9fd1826ac251752995cb', // replace *** with Account SID
                                                authToken:
                                                    'd94431e5df6dac77262a2f007e0d934f', // replace xxx with Auth Token
                                                twilioNumber:
                                                    '+18573746722' // replace .... with Twilio Number
                                                );

                                        twilioFlutter
                                            .sendSMS(
                                                toNumber: item.get('phone'),
                                                messageBody:
                                                    '\n Ombi lako katika WARMA limekataliwa,sababu ni: \n${kataaController.text}')
                                            .then((value) {})
                                            .catchError((val) {
                                          print(val);
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("successfully",
                                              style: TextStyle(fontSize: 16)),
                                          duration: Duration(seconds: 5),
                                        ));
                                        // if(Authen)
                                        // if (snapshot.data!.get('acceptedUser') ==
                                        //     AuthenticationHelper().user.uid) {
                                        //   db
                                        //       .collection("accessories")
                                        //       .doc(widget.ukumbi.get('ukumbi_id'))
                                        //       .update({"acceptedUser": null})
                                        //       .then((value) {})
                                        //       .onError((error, stackTrace) {
                                        //         ScaffoldMessenger.of(context)
                                        //             .showSnackBar(SnackBar(
                                        //           content:
                                        //               Text("There was a problem"),
                                        //         ));
                                        //       });
                                        // }
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("There was a problem"),
                                        ));
                                      });
                                    },
                                    child: Text("Deny"),
                                  ))
                            ]);
                          }),
                    ],
                  );
                }),

            // Text(
            //   "Chukua Hatua",
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Text(
            //     "NB: Kama ulishakubali ukakubali tena hapa, maombi ya awali yote yatakuwa yamekataliwa "),
          ]),
        ));
  }
}
