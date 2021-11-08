// import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider with ChangeNotifier {
  late User? user;

  Future<void> setUser() async {
    try {
      await Firebase.initializeApp();
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("Error in setting user " + e.toString());
    }
  }

  bool isAuthenticated() {
    return user != null;
  }

  User? getUser() {
    return user;
  }

  String getUserId() {
    return user!.uid;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithGoogle() async {
    try {
      await Firebase.initializeApp();

      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      print((result.user?.email).toString() + " Authenticated");
    } catch (error) {
      print("Error in sign in  : " + error.toString());
    }
  }
}
