import 'package:event_planner/components/CustomeDrawer.dart';
import 'package:event_planner/models/Ukumbi.dart';
import 'package:event_planner/utils/authentication.dart';
import 'package:event_planner/utils/constants.dart';
import 'package:event_planner/utils/DB.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:io';

class UkumbiRegisterScreen extends StatefulWidget {
  UkumbiRegisterScreen({Key? key}) : super(key: key);
  @override
  State<UkumbiRegisterScreen> createState() => _UkumbiRegisterScreenState();
}

class _UkumbiRegisterScreenState extends State<UkumbiRegisterScreen> {
  DB _db = new DB();
  File? _photo;
  bool _imageStartSelection = false;
  File? _photo2;
  bool _imageStartSelection2 = false;
  final _formKey = GlobalKey<FormState>();
  bool categoryError = false;
  final userId = AuthenticationHelper().user.uid;
  TextEditingController locationController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  final ukumbiRegisterFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomHomeDrawer(),
      body: Container(
        child: Form(
          key: ukumbiRegisterFormKey,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Register Ukumbi",
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.black),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Ukumbi Name is required'
                          : null,
                      decoration: const InputDecoration(
                        label: Text("Ukumbi Name"),
                        hoverColor: Colors.black26,
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
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
                          items: Ukumbi.categories,
                          dropdownSearchDecoration: InputDecoration(
                            label: Text("Category"),
                          ),
                          // popupItemDisabled: (String s) => s.startsWith('I'),
                          onChanged: (data) {
                            setState(() {
                              categoryController.text = data as String;
                            });
                          },
                          selectedItem: Ukumbi.categories[0],
                        ),
                        categoryError ? Text("Category is required") : Text(''),
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: aboutController,
                        decoration: InputDecoration(label: Text("About")),
                      )),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(label: Text("Location")),
                      )),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        onChanged: (v) {
                          if (_imageStartSelection) {}
                        },
                        onTap: () async {
                          _imageStartSelection = true;
                          _photo = await _db.imgFromGallery();
                        },
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(label: Text("Image")),
                      )),
                  _imageStartSelection
                      ? Container(
                          child: Text("Image Selected"),
                        )
                      : Container(),
                  Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      child: TextFormField(
                        onChanged: (v) {
                          if (_imageStartSelection2) {}
                        },
                        onTap: () async {
                          _imageStartSelection2 = true;
                          _photo2 = await _db.imgFromGallery();
                        },
                        keyboardType: TextInputType.none,
                        decoration: InputDecoration(label: Text("Image")),
                      )),
                  _imageStartSelection2
                      ? Container(
                          child: Text("Image Selected"),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: ElevatedButton(
                        child: Text("Register"),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (categoryController.text == '' ||
                                categoryController.text == null) {
                              _db.create(
                                  collection: "ukumbi",
                                  data: {
                                    "category": categoryController.text,
                                    "about": aboutController.text,
                                    "location": locationController.text,
                                    "name": nameController.text,
                                    "image": _photo!.path,
                                    "image2": _photo2!.path,
                                    "uid": AuthenticationHelper().user.uid,
                                  },
                                  onErr: () {
                                    print("Error when create ukumbi occured");
                                  },
                                  docsId: AuthenticationHelper().user.uid);
                              _db.uploadFile(
                                  photo: _photo,
                                  userId: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString() +
                                      userId);
                              _db.uploadFile(
                                  photo: _photo,
                                  userId: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString() +
                                      userId);
                            }
                          }
                        },
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
