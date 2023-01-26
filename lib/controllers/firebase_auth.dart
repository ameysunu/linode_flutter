import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

loginUsingFirebase(email, password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('Logged in successfully with user: $user');
  } catch (e) {
    print('Error logging in: $e');
  }
}
