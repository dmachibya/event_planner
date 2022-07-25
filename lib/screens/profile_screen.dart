import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils/authentication.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final db = FirebaseFirestore.instance;

  bool isLoggingOut = false;

  File? _photo;
  // this variable used to store the future _fetchData function inorder to avoid loop on a future builder
  // late final Future? _fetchDataFuture;
  //image url variable
  String profileImageUrl = '';
  final ImagePicker _picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var name = AuthenticationHelper().user.uid;

  Map<String, dynamic> userObject = {};
  // final db = FirebaseFirestore.instance;

  // @override
  @override
  void initState() {
    super.initState();
    //initialize the variable with the future function
    // _fetchDataFuture = _fetchData();
    initValues();
  }

  void initValues() async {
    await db
        .collection("users")
        .doc(AuthenticationHelper().user.uid)
        .get()
        .then((snapshot) => {userObject = snapshot.data()!});
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '/';
    var temp = _photo!.path.split(".");
    var extension = temp[temp.length - 1];
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(name + "." + extension);
      var uploadTask = ref.putFile(_photo!);

      await uploadTask.whenComplete(() {
        ref.getDownloadURL().then((value) {
          db.collection("users").doc(name).update({'photo': value});
          setState(() {
            profileImageUrl = value;
          });
        });
      });
    } catch (e) {
      print('error occured while uploading image ' + e.toString());
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
      child: ListView(
        children: [
          Text(
            "Account",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          AuthenticationHelper().user != null
              ? FutureBuilder(
                  future: db
                      .collection("users")
                      .doc(AuthenticationHelper().user.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text("loading...");
                      default:
                        if (snapshot.hasError) {
                          return Text("There was an error");
                        } else {
                          var item_data = snapshot.data;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    child: Row(children: [
                                  SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Stack(
                                      children: [
                                        Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: profileImageUrl == ''
                                                ? snapshot.data!
                                                            .data()
                                                            .toString()
                                                            .contains(
                                                                'photo') &&
                                                        snapshot.data!
                                                                .get('photo') !=
                                                            ""
                                                    ? ClipRRect(
                                                        child: Image.network(
                                                            snapshot.data!
                                                                .get("photo")),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                60))
                                                    : Icon(Icons.person,
                                                        size: 32)
                                                : ClipRRect(
                                                    child: Image.network(profileImageUrl),
                                                    borderRadius: BorderRadius.circular(60))),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: InkWell(
                                              onTap: () {
                                                imgFromGallery();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color: Colors.grey.shade700,
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item_data!.get('name'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6),
                                        Text(
                                          item_data!.get('email'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.blue),
                                        )
                                      ])
                                ]))
                              ]);
                        }
                    }
                  })
              : Container(),
          Divider(color: Colors.grey.shade500),
          SizedBox(
            height: 40,
          ),
          AuthenticationHelper().user != null && AuthenticationHelper().isAdmin
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Admin Menu",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      onTap: () {
                        GoRouter.of(context).go('/home/ukumbi_register');
                      },
                      leading: Icon(Icons.add),
                      title: Text("Register Accessory"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey.shade500),
                    ListTile(
                      onTap: () {
                        GoRouter.of(context).go("/home/kumbi_zako");
                      },
                      leading: Icon(Icons.list),
                      title: Text("All Accessories"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey.shade500),
                    ListTile(
                      onTap: () {
                        GoRouter.of(context).go("/home/maombi_kukodi");
                      },
                      leading: Icon(Icons.list),
                      title: Text("Requested Accessories"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey.shade500),
                    ListTile(
                      onTap: () {
                        GoRouter.of(context).go("/home/users");
                      },
                      leading: Icon(Icons.list),
                      title: Text("Users"),
                      trailing: Icon(Icons.chevron_right),
                    ),
                    Divider(color: Colors.grey.shade500),
                    Divider(color: Colors.grey.shade500),
                  ],
                )
              : Container(),
          AuthenticationHelper().user != null
              ? InkResponse(
                  onTap: () {
                    setState(() {
                      isLoggingOut = true;
                    });
                    AuthenticationHelper().signOut().then((value) {
                      GoRouter.of(context).go("/login");

                      setState(() {
                        isLoggingOut = false;
                      });
                    }).onError((error, stackTrace) {
                      setState(() {
                        isLoggingOut = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Failed to log out, try again in a while")));
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text("Log out",
                        style: Theme.of(context).textTheme.headline6),
                  ))
              : Container(),
        ],
      ),
    )));
  }
}
