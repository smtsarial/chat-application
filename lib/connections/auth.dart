import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    UserCredential userCredentials = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredentials.user;
    return user?.uid ?? "HATA";
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredentials.user;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    try {
      _firebaseAuth.currentUser!.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<String?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user?.email;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        value;
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
