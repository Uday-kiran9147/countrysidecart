import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countrysidecart/constants/shared_prefs.dart';
import 'package:countrysidecart/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
FirebaseFirestore firestore = FirebaseFirestore.instance;
// generate collection references firebase
final CollectionReference usersCollection = firestore.collection('users');
final CollectionReference bussinessCollection =
    firestore.collection('bussiness');
final CollectionReference productsCollection = firestore.collection('products');

Future<void> registerWithEmailAndPassword(
  String email,
  String password,
  String username,
  String location,
  String contact,
) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() async {
      UserApp newuser = UserApp(
          userId: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          email: email,
          password: password,
          bussinessId: uuid.v1(),
          location: location,
          preferences: [],
          transactionHistory: []);
      await usersCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(newuser.toMap());
    });
    print("User registered: ${userCredential.user?.uid}");
  } catch (e) {
    // print("Error during registration: $e");
    Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.redAccent,
        toastLength: Toast.LENGTH_LONG);
  }
}

Future<bool> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("User signed in: ${userCredential.user?.uid}");
    SHP.saveUserLoggedinStatusSP(true);
    return true;
  } catch (e) {
    print("Error during sign in: $e");
    Fluttertoast.showToast(msg: e.toString());
    return false;

  }
}

// create functio to signout
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}

// FirebaseAuth.instance.authStateChanges().listen((User? user) {
//   if (user == null) {
//     // User is signed out
//     print('User is currently signed out!');
//   } else {
//     // User is signed in
//     print('User is signed in!');
//     // Navigate to home screen or any other authenticated screen
//   }
// });

