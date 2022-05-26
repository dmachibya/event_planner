import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path/path.dart';

class DB {
  final db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<bool> update(
      {required String collection,
      required String docsId,
      required Map<String, dynamic> data}) async {
    //just use await and use if statement to check if updated
    bool updated = true;
    await db
        .collection(collection)
        .doc(docsId)
        .set({...data}, SetOptions(merge: true)).onError(
            (error, stackTrace) => {updated = false});
    return updated;
  }

  Future<bool> create(
      {required String collection,
      required String docsId,
      required Map<String, dynamic> data,
      required void Function() onErr}) async {
    // just use await and use if statement to check if created
    bool created = true;
    await db
        .collection(collection)
        .doc(docsId)
        .set({...data}).onError((error, stackTrace) => {onErr(),created=false});
    return created;
  }

  Future<DocumentReference<Map<String, dynamic>>> createRandomId(
      {required String collection, required Map<String, dynamic> data}) async {
    // you will have to use the dot then to access a data
    return await db.collection(collection).add({...data});
  }

  Future<bool> delete(
      {required String collection, required String document}) async {
    bool deleted = false;
    db.collection(collection).doc(document).delete().then(
          (doc) => deleted = true,
          onError: (e) => deleted = false,
        );
    return deleted;
  }

  Future<bool> deleteField(
      {required String collection,
      required String document,
      required String fieldName}) async {
    bool fieldDeleted = false;
    db
        .collection(collection)
        .doc(document)
        .update({fieldName: FieldValue.delete()}).then(
      (doc) => fieldDeleted = true,
      onError: (e) => fieldDeleted = false,
    );
    return fieldDeleted;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> select(
      {required String collection, required String document}) async {
        // this method returns type _JsonQueryDocumentSnapshot to access
        // the data from it use snapshot.data.data() to get the data of the document
    return await db.collection(collection).doc(document).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> selectAllDocumentOnCollection(
      String collection) async {
    //this function return type _JsonQuerySnapshot which is an array
    //to access them use snapshot.data.docs to get all the docs then
    //in each doc to access the data use snapshot.data.docs[0].data()
    //you will get the data of the document
    // also you can cast the data to list inorder to use .map() function
    //example var data= datasnapshot.data.docs as List<dynamic>;
    // data.map((document)=>{});
    return await db.collection(collection).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> where(
      {required String collection,
      required String document,
      required String column,
      required String condition,
      required value,
      List<String>? anyvalue}) async {
    //you will need to use the .then to check it .then((res)=>{} ,onError:(e)=>{print(e)});
    switch (condition) {
      case "=":
        return await db
            .collection(collection)
            .where(column, isEqualTo: value)
            .get();
      case "!=":
        return await db
            .collection(collection)
            .where(column, isNotEqualTo: value)
            .get();
      case "<":
        return await db
            .collection(collection)
            .where(column, isLessThan: value)
            .get();
      case ">":
        return await db
            .collection(collection)
            .where(column, isGreaterThan: value)
            .get();
      case "<=":
        return await db
            .collection(collection)
            .where(column, isLessThanOrEqualTo: value)
            .get();
      case ">=":
        return await db
            .collection(collection)
            .where(column, isGreaterThanOrEqualTo: value)
            .get();
      case "contains":
        return await db
            .collection(collection)
            .where(column, arrayContains: value)
            .get();
      case "containsany":
        return await db
            .collection(collection)
            .where(column, arrayContainsAny: [...?anyvalue]).get();
      case "wherein":
        return await db
            .collection(collection)
            .where(column, whereIn: value)
            .get();
      case "wherenotin":
        return await db
            .collection(collection)
            .where(column, whereNotIn: value)
            .get();
      case "isnull":
        return await db
            .collection(collection)
            .where(column, isNull: value)
            .get();
      default:
        return await db
            .collection(collection)
            .where(column, isEqualTo: value)
            .get();
    }
  }

  Future orderby(
      {required String collection,
      required String column,
      required String orderby}) async {
    switch (orderby) {
      case "ASC":
        return await db.collection(collection).orderBy(column);
      case "DESC":
        return await db
            .collection(collection)
            .orderBy(column, descending: true);
      default:
        return await db.collection(collection).orderBy(column);
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }
  Future<String> getDownloadImageOrFileUrl(String url)async{
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(url);
    return await ref.getDownloadURL();
  }

  Future<String> uploadFile(
      {required File? photo,
      required String userId,
      String destination = '/'}) async {
    if (photo == null) {
      print('No Image selected');
      return "null";
    }
    final fileName = basename(photo.path);
    var temp = photo.path.split(".");
    var extension = temp[temp.length - 1];
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(userId + "." + extension);
      await ref.putFile(photo);
      return await ref.getDownloadURL();
      // db
      //     .collection("users")
      //     .doc(userId)
      //     .update({'photo': userId + '.' + extension});
    } catch (e) {
      print('error occured while uploading image ' + e.toString());
      return "null";
    }
  }
}
