// import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprint/models/user_model.dart';

class LoginProvider with ChangeNotifier {
  late UserData? user;
  late final FirebaseAuth auth;

  Future<FirebaseApp?> initializeApp() async {
    try {
      return await Firebase.initializeApp();
    } catch (e) {
      print("Error initializing the firebase app : " + e.toString());
    }
  }

  void setAuthInstance() {
    try {
      auth = FirebaseAuth.instance;
    } catch (e) {
      print("Error getting auth instance : " + e.toString());
    }
  }

  Future<void> setUser() async {
    try {
      User? firebaseUser = auth.currentUser;
      if (firebaseUser == null) {
        user = null;
      } else {
        user = UserData(
            uid: firebaseUser.uid,
            displayName: (firebaseUser.displayName ?? ""),
            email: (firebaseUser.email ?? ""));
      }
    } catch (e) {
      print("Error in setting user " + e.toString());
    }
  }

  bool isAuthenticated() {
    return user != null;
  }

  Future<void> initialSetup() async {
    return await initializeApp()
        .then((_) async {
          setAuthInstance();
          return await setUser();
        })
        .then((value) => print("User setup complete"))
        .catchError((e) =>
            print("Error occured while setting up the user : " + e.toString()));
  }

  UserData getUser() {
    return UserData(
        uid: user!.uid, displayName: user!.displayName, email: user!.email);
  }

  String getUserId() {
    return user!.uid;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    try {
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
