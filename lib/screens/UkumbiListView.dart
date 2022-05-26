import 'package:event_planner/models/Ukumbi.dart';
import 'package:event_planner/utils/DB.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UkumbiListView extends StatefulWidget {
  UkumbiListView({Key? key}) : super(key: key);
  State<UkumbiListView> createState() => _UkumbiListViewState();
}

class _UkumbiListViewState extends State<UkumbiListView> {
  final List<Ukumbi> ukumbiList = [];
  TextEditingController selectedBookingDateController = TextEditingController();
  DB _db = DB();
  bool setstate = false;
  Future<dynamic>? _getUkumbiList;
  var _imageObjectList = [];
  @override
  void initState() {
    super.initState();
    _getUkumbiList = _getUkumbis();
  }

  Future _getUkumbis() async {
    var ukumbis = await _db.selectAllDocumentOnCollection("ukumbi");
    // for (var document in ukumbis.docs) {
    //   var image = await _db.getDownloadImageOrFileUrl(document.data()["image"]);
    //   var image2 =
    //       await _db.getDownloadImageOrFileUrl(document.data()["image2"]);
    //   setState(() {
    //     _imageObjectList.add({"image": image, "image2": image2});
    //   });
    // }
    return ukumbis;
  }

  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: _getUkumbiList,
          initialData: ukumbiList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data.docs as List<dynamic>;
              if(setstate){
                setState(() {
                });
              }
              return ListView(
                children: data
                    .map((document) => ListTile(
                          onTap: () => {
                            Navigator.pushNamed(context, ukumbiDetailScreen,
                                arguments: new Ukumbi(
                                    isBookedDate: "isBookedDate",
                                    isBooked: false,
                                    location: document.data()['location'],
                                    about: document.data()['about'],
                                    category: document.data()['category'],
                                    image: {
                                      "image": document.data()['image'],
                                      'image2': document.data()['image2']
                                    },
                                    name: document.data()['name'],
                                    uid: document.data()['uid']))
                          },
                          trailing: Column(
                            children: [
                              ElevatedButton(
                                  onPressed: document.data()['isBooked']
                                      ? null
                                      : () async {
                                          var result = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: Text('Start Book ' +
                                                  document.data()['name']),
                                              content: TextFormField(
                                                  onTap: () =>
                                                      _showSelectDate(context),
                                                  keyboardType:
                                                      TextInputType.none,
                                                  controller:
                                                      selectedBookingDateController,
                                                  decoration: InputDecoration(
                                                      label:
                                                          Text("Choose Date"))),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, true),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                          try {
                                            if (result != null &&
                                                result == true) {
                                              bool updated = await _db.update(
                                                  collection: "ukumbi",
                                                  docsId: document.id,
                                                  data: {
                                                    "isBooked": true,
                                                    "isBookedDate":
                                                        selectedBookingDateController
                                                            .text
                                                  });
                                              if (updated) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Ukumbi booked successully",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Text(
                                                      "Could not book successully",
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ));
                                              }
                                            }
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "An error occured Could not book successully",
                                                  style: TextStyle(
                                                      fontSize: 16)),
                                              duration:
                                                   Duration(seconds: 5),
                                            ));
                                          }
                                        },
                                  child: Text(document.data()['isBooked']
                                      ? "Occupied"
                                      : "Book now")),
                            ],
                          ),
                          subtitle: Text(
                            document.data()['about'],
                            style: TextStyle(overflow: TextOverflow.ellipsis),
                          ),
                          leading: Image.network(document.data()['image']),
                          title: Text(
                            document.data()['name'],
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ))
                    .toList(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()));
            }
            return Center(child: Text("Hellow"));
          },
        ),
      ),
    );
  }

  Future<void> _showSelectDate(BuildContext context) async {
    var dateSelect = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2040));
    if (dateSelect != null) {
      DateFormat dateFormat = DateFormat("yyyy-mm-dd");
      final selctedFormatedDate = dateFormat.format(dateSelect);
      setState(() {
        selectedBookingDateController.text = selctedFormatedDate;
      });
    }
  }
}
