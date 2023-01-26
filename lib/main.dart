import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linode_flutter/home.dart';
import 'package:linode_flutter/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (FirebaseAuth.instance.currentUser != null) {
    runApp(MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));
  } else {
    runApp(MaterialApp(
      home: UserLogin(),
      debugShowCheckedModeBanner: false,
    ));
  }
}
