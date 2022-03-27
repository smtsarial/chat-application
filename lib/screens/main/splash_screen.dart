import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/providers/userProvider.dart';
import 'package:firebasedeneme/screens/auth/login.dart';
import 'package:firebasedeneme/screens/main/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final StreamSubscription<firebase.User?> listener;
  late String userUID = "";

  Future<void> _handleAuthenticatedState() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userUID");
    print(_usermail);
    setState(() {
      userUID = _usermail.toString();
    });
  }

  @override
  void initState() {
    _handleAuthenticatedState().then((value) {});
    FirestoreHelper.getUserData().then((value) => print(value.email));

    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userUID.length != 0 ? (HomeScreen()) : (LoginPage()),
    );
  }
}
