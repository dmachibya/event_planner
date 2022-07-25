import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  get isAdmin => _auth.currentUser!.email == "admin@weddingapp.com";

  get test => "Auth";

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //SIGN UP METHOD
  Future signUp(
      {required String email,
      required String password,
      required String phone,
      required String role,
      required name}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = result.user!;
      users.doc(currentUser.uid).set({
        "name": name,
        "role": 0,
        "phone": phone,
        "photo": "",
        "verified": currentUser.emailVerified,
        "email": currentUser.email,
      }).then((documentReference) {
        // print("success");
        // return true;
        // Navigator.pushNamed(context, productRoute);
        // print(documentReference!.documentID);
        // clearForm();
      }).catchError((e) {
        return e;
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final currentUser = result.user!;
      // print("user");
      print(currentUser);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }

  Future resetPassword({required String email}) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) {})
        .catchError((e) {});
    return null;
  }
}
