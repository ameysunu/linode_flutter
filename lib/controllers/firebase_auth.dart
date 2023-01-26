import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
bool isSuccess = false;

loginUsingFirebase(email, password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('Logged in successfully with user: $user');
    isSuccess = true;
  } catch (e) {
    print('Error logging in: $e');
    isSuccess = false;
  }
}

registerUsers(email, password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    print('Created user successfully');
    isSuccess = true;
  } catch (e) {
    print('Error logging in: $e');
    isSuccess = false;
  }
}

logoutFirebase() async {
  await FirebaseAuth.instance.signOut();
}
