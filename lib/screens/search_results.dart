import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'warma_detailScreen.dart';

class SearchResults extends StatefulWidget {
  String? category;
  String? keyword;
  SearchResults({
    Key? key,
    this.category,
    this.keyword,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter Accessories")),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.category != null
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Category: ${widget.category!.replaceAll("\n", "")}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Container(),
        widget.keyword != null
            ? Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "Searching: ${widget.keyword}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              )
            : Container(),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("accessories")
                    .where('category', isEqualTo: widget.category)
                    .snapshots(),
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
                    return Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text("Currently no data"),
                    );
                  }

                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return UkumbiDetailScreen(ukumbi: items[index]);
                            }));
                          },
                          child: customCard(items, index, context),
                        );
                      });
                })))
      ]),
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
