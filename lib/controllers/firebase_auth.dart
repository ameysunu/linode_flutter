import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linode_flutter/login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
// bool isSuccess = false;
Future<bool> loginUsingFirebase(email, password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('Logged in successfully with user: $user');
    return true;
  } catch (e) {
    print('Error logging in: $e');
    return false;
  }
}

Future<bool> registerUsers(email, password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('Logged in successfully with user: $user');
    return true;
  } catch (e) {
    print('Error logging in: $e');
    return false;
  }
}

Future<void> logoutFirebase(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => UserLogin()),
    (Route<dynamic> route) => false,
  );
}
