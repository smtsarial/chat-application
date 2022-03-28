import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/home_screen.dart';
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
  User userData = User("", "", 0, 0, "", [], [], "", true, DateTime.now(), "",
      "", [], "", [], "", "", "", "");
  Future<void> _handleAuthenticatedState() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userUID");

    print("asfasf" + _usermail.toString());
    setState(() {
      userUID = _usermail.toString();
    });
  }

  @override
  void initState() {
    FirestoreHelper.getUserData().then((value) {
      setState(
        () {
          userData = value;
        },
      );
    });

    _handleAuthenticatedState().then((value) {});
    super.initState();
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return userData.id != ""
        ? (MultiProvider(
            providers: [
                ChangeNotifierProvider<MessageRoomProvider>(
                  create: ((context) => MessageRoomProvider(userData)),
                ),
              ],
            child: Scaffold(
              body: userUID.length != 0 ? (HomeScreen()) : (LoginPage()),
            )))
        : Scaffold(
            body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: Colors.blueGrey,
              strokeWidth: 2,
            ),
          ));
  }
}
