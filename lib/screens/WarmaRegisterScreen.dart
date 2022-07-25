import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/components/CustomeDrawer.dart';
import 'package:event_planner/screens/home_screen.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:event_planner/utils/DB.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:io';

import 'package:go_router/go_router.dart';

import '../components/list_data.dart';

class WarmaRegisterScreen extends StatefulWidget {
  WarmaRegisterScreen({Key? key}) : super(key: key);
  @override
  State<WarmaRegisterScreen> createState() => _WarmaRegisterScreenState();
}

class _WarmaRegisterScreenState extends State<WarmaRegisterScreen> {
  DB _db = new DB();
  File? _photo;

  bool _imageStartSelection = false;
  File? _photo2;

  bool _imageStartSelection2 = false;
  final _formKey = GlobalKey<FormState>();
  bool categoryError = false;

  bool isImg1 = false;
  bool isImg2 = false;

  bool isClicked = false; // for disabling submit button

  final userId = AuthenticationHelper().user.uid;
  TextEditingController locationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final WarmaRegisterFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Accessory"),
      ),
      body: Container(
        child: Form(
          key: WarmaRegisterFormKey,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please write accessory name'
                          : null,
                      decoration: const InputDecoration(
                        label: Text("Accessory Name"),
                        hoverColor: Colors.black26,
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        DropdownSearch<String>(
                          mode: Mode.MENU,
                          popupBackgroundColor: Colors.white,
                          showSelectedItems: true,
                          items: categories_string,
                          dropdownSearchDecoration: InputDecoration(
                            label: Text("Aina ya Warma"),
                          ),
                          // popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (data) {
                            setState(() {
                              categoryController.text = data as String;
                            });
                          },
                          selectedItem: categories_string[0],
                        ),
                        categoryError
                            ? Text("Aina ya Warma inatakiwa")
                            : Text(''),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description must be filled';
                          }

                          return null;
                        },
                        controller: aboutController,
                        maxLines: 3,
                        decoration: InputDecoration(label: Text("Description")),
                      )),
                  // Container(
                  //     padding: EdgeInsets.all(8),
                  //     margin: EdgeInsets.all(8),
                  //     child: TextFormField(
                  //       controller: locationController,
                  //       decoration: InputDecoration(label: Text("Mahali")),
                  //     )),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      controller: priceController,
                      // keyboardType: KeyboardTy,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Price must be filled';
                        }
                        int val = int.tryParse(value) ?? 0;

                        if (val == 0) {
                          return "Please fill in the price as number";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text("Price"),
                        hoverColor: Colors.black26,
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10),
                    child: Text("Pictures",
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Row(children: [
                    Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        child: InkWell(
                          onTap: () async {
                            _imageStartSelection = true;
                            await _db.imgFromGallery().then((value) {
                              if (value != null) {
                                setState(() {
                                  isImg1 = true;
                                  _photo = value;
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            width: 80,
                            height: 80,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade300),
                            child: isImg1
                                ? Image.file(
                                    _photo!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.photo_camera,
                                  ),
                          ),
                        )),
                  ]),
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                          // enabled: isEditable,
                        ),
                        child: Text("Register"),
                        onPressed: !isClicked
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isClicked = true;
                                  });

                                  // var array = ["null"];
                                  FirebaseFirestore.instance
                                      .collection("accessories")
                                      .add({
                                    "category": categoryController.text,
                                    "about": aboutController.text,
                                    "location": locationController.text,
                                    "name": nameController.text,
                                    "price": priceController.text,
                                    "bookValue": 0,
                                    "isBooked": false,
                                    "isBookedAccepted": false,
                                    "isBookedDate": null,
                                    "acceptedUser": null,
                                    "image": "null",
                                    "image2": "null",
                                    "user_id": AuthenticationHelper().user.uid,
                                  }).then((doc_value) {
                                    var imagePath = _db
                                        .uploadFile(
                                            photo: _photo,
                                            userId: DateTime.now()
                                                    .millisecondsSinceEpoch
                                                    .toString() +
                                                userId)
                                        .then((value) {
                                      FirebaseFirestore.instance
                                          .collection("accessories")
                                          .doc(doc_value.id)
                                          .update({"image": value}).then(
                                              (value) {
                                        GoRouter.of(context).go("/home");
                                        setState(() {
                                          isClicked = false;
                                        });
                                      }).onError((error, stackTrace) {
                                        setState(() {
                                          isClicked = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(error.toString())));
                                      });
                                    }).onError((error, stackTrace) {
                                      setState(() {
                                        isClicked = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(error.toString())));
                                    });
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      isClicked = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "There was a problem, try again later")));
                                  });
                                }
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}