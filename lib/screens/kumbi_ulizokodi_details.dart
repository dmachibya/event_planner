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
            "Taarifa za Mwenye Ukumbi",
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
          Text(
            "Hali ya maombi yako",
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
                    child: Text("Inapakua..."),
                  );
                }
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Hakuna taarifa"),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                      padding: EdgeInsets.all(28.0),
                      child: Text("Kuna tatizo, jaribu tena baadae"));
                }
                var isThisUser = widget.ukumbi.get('active');
                return Text(
                  widget.ukumbi.get('status') == 1
                      ? 'umekubaliwa'
                      : widget.ukumbi.get('status') == 0
                          ? 'inachakatwa'
                          : 'umekataliwa',
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
