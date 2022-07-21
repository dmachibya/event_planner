import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/authentication.dart';

class KumbiUlizoKodiDetailScreen extends StatefulWidget {
  final ukumbi;
  KumbiUlizoKodiDetailScreen({Key? key, required this.ukumbi})
      : super(key: key);

  @override
  State<KumbiUlizoKodiDetailScreen> createState() =>
      _KumbiUlizoKodiDetailScreenState();
}

class _KumbiUlizoKodiDetailScreenState
    extends State<KumbiUlizoKodiDetailScreen> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maombi ya Kumbi Yako")),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Renting details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text("Accessory"),
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
            "Admin information",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(widget.ukumbi.get('user_owns'))
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
                    child: Text("There was a problem..."),
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
                        Text("Fullname"),
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
                        Text("Phone Number"),
                        Spacer(),
                        Text(
                          item!.get('phone'),
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
                          item!.get('email'),
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
          Text(
            "Your request status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                    child: Text("Loading..."),
                  );
                }
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text("No data found"),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("There was problem please try again later"));
                }
                return Text(
                  widget.ukumbi.get('status') == 1
                      ? 'Accepted'
                      : widget.ukumbi.get('status') == 0
                          ? 'pending'
                          : 'denied',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: widget.ukumbi.get('status') == 1
                            ? Colors.green
                            : widget.ukumbi.get('status') == 0
                                ? Colors.grey
                                : Colors.red,
                      ),
                );
              })
        ]),
      ),
    );
  }
}
