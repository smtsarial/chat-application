import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

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

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      print("not null");
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          print(e);
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          print(e);
        }
      } catch (e) {
        // handle the error here
        print(e);
      }
    } else {
      print("null geldi");
    }

    return user;
  }
}
