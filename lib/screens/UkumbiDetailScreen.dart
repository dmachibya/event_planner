// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';
import 'package:event_planner/utils/DB.dart';

class UkumbiDetailScreen extends StatefulWidget {
  final dynamic ukumbi;
  UkumbiDetailScreen({
    required this.ukumbi,
    Key? key,
  }) : super(key: key);

  @override
  State<UkumbiDetailScreen> createState() => _UkumbiDetailScreenState();
}

class _UkumbiDetailScreenState extends State<UkumbiDetailScreen> {
  var size, height, width;
  var paddingRatio = 0.068;

  DB _db = DB();
  TextEditingController selectedBookingDateController = TextEditingController();

  //picking center
  String? pickingCenter = "Mianzini Center";
  bool isPickingFromCenter = false;
  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController quantityController;
  //firestore instance

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController = TextEditingController(text: "1");
  }

  final db = FirebaseFirestore.instance;

  var dropDownValue = '1. Pick from the merchant';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    var checkedValue = "";
    PageController _pageController = PageController(viewportFraction: 0.8);
    const List<String> _kOptions = <String>[
      'aardvark',
      'bobcat',
      'chameleon',
    ];

    // add images to pageview
    if (widget.ukumbi!.get('image') != 'null') {
      images[0] = widget.ukumbi!.get('image');
    }
    if (widget.ukumbi!.get('image2') != 'null') {
      images.add(widget.ukumbi!.get('image2'));
    }
    // if (widget.item.data().toString().contains('img2') &&
    //     widget.item.get('img2') != '') {
    //   images.add(widget.item.get('img2'));
    // }
    // if (widget.item.data().toString().contains('img3') &&
    //     widget.item.get('img3') != '') {
    //   images.add(widget.item.get('img3'));
    // }

    var item_price = widget.ukumbi!.get('price');

    var item_name = widget.ukumbi!.get('name');
    // var item_price = widget.item.data().toString().contains('price')
    //     ? widget.item.get('price')
    //     : '';

    GlobalKey formKey = GlobalKey();
    return Scaffold(
      // endDrawer: AppDrawer.getDrawer(context),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          widget.ukumbi!.get('name'),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(bottom: 60),
          child: ListView(children: [
            Container(
                width: width,
                height: height * 0.6,
                child: Stack(children: [
                  CarouselSlider(
                      items: images
                          .map((e) => Builder(builder: (BuildContext context) {
                                return Image.network(e, fit: BoxFit.cover);
                              }))
                          .toList(),
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 15),
                        autoPlayAnimationDuration: Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        // onPageChanged: callbackFunction,
                        scrollDirection: Axis.horizontal,
                      )),
                ])),
            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * paddingRatio,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TZS $item_price",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ReadMoreText(
                      widget.ukumbi!.get("about"),
                      trimLines: 2,
                      style: TextStyle(color: Colors.grey.shade700),
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Onesha yote',
                      trimExpandedText: 'Onesha kidogo',
                      moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
          ])),
      bottomSheet: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconButton(
            //     icon: Icon(Icons.store_mall_directory_outlined),
            //     onPressed: () {}),
            Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // NEW
                      // enabled: isEditable,
                    ),
                    onPressed: widget.ukumbi.get('isBookedAccepted') ||
                            widget.ukumbi.get('user_id') ==
                                AuthenticationHelper().user.uid
                        ? null
                        : () async {
                            var result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                    'Kodi Sasa - ' + widget.ukumbi.get('name')),
                                content: TextFormField(
                                    onTap: () => _showSelectDate(context),
                                    keyboardType: TextInputType.none,
                                    controller: selectedBookingDateController,
                                    decoration: InputDecoration(
                                        label: Text("Choose Date"))),
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
                            if (widget.ukumbi.get('acceptedUser') != null &&
                                widget.ukumbi.get('isBookedDate').contains(
                                    selectedBookingDateController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Ukumbi umekwisha kodishwa siku hiyo"),
                                  duration: Duration(seconds: 10),
                                ),
                              );
                            } else {
                              try {
                                if (result != null && result == true) {
                                  List array =
                                      widget.ukumbi.get('isBookedDate');
                                  array.add(selectedBookingDateController.text);
                                  bool updated = await _db.update(
                                      collection: "ukumbi",
                                      docsId: widget.ukumbi.id,
                                      data: {
                                        "isBooked": true,
                                        "isBookedAccepted": false,
                                        "isBookedDate":
                                            FieldValue.arrayUnion(array)
                                      });

                                  await FirebaseFirestore.instance
                                      .collection("bookings")
                                      .add({
                                    "date": selectedBookingDateController.text,
                                    "user_booked":
                                        AuthenticationHelper().user.uid,
                                    "user_owns": widget.ukumbi.get('user_id'),
                                    "status": 0,
                                    "ukumbi_id": widget.ukumbi.id,
                                    "ukumbi_name": widget.ukumbi.get('name'),
                                    "ukumbi_price": widget.ukumbi.get('price'),
                                  });

                                  if (updated) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Ombi lako la kukodi limetumwa",
                                          style: TextStyle(fontSize: 16)),
                                      duration: Duration(seconds: 3),
                                    ));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          "Tatizo limetokea imeshindikana kuweka nafasi",
                                          style: TextStyle(fontSize: 16)),
                                      duration: Duration(seconds: 3),
                                    ));
                                  }
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Tatizo limetokea imeshindikana kuweka nafasi",
                                      style: TextStyle(fontSize: 16)),
                                  duration: Duration(seconds: 5),
                                ));
                              }
                            }
                          },
                    child: Text(widget.ukumbi.get('isBookedAccepted')
                        ? "Umechukuliwa"
                        : "Kodi Sasa")))
            // DecoratedBox(
            //     decoration: BoxDecoration(
            //         gradient: LinearGradient(colors: [
            //           Colors.teal,
            //           Colors.teal.shade300,
            //           //add more colors
            //         ]),
            //         borderRadius: BorderRadius.circular(30),
            //         boxShadow: const <BoxShadow>[
            //           BoxShadow(
            //               color:
            //                   Color.fromRGBO(0, 0, 0, 0.3), //shadow for button
            //               blurRadius: 5) //blur radius of shadow
            //         ]),
            //     child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //           primary: Colors.transparent,
            //           onSurface: Colors.transparent,
            //           shadowColor: Colors.transparent,
            //           padding:
            //               EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            //           //make color or elevated button transparent
            //         ),
            //         onPressed: () {},
            //         child: Text("Buy Now"))),
          ],
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
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      final selctedFormatedDate = dateFormat.format(dateSelect);
      setState(() {
        selectedBookingDateController.text = selctedFormatedDate;
      });
    }
  }
}
