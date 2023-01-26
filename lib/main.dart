import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linode_flutter/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: UserLogin(),
    debugShowCheckedModeBanner: false,
  ));
}
