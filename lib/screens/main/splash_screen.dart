import 'dart:async';
import 'package:anonmy/connections/local_notification_api.dart';
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

import '../../theme.dart';

class SplashScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User userData = emptyUser;

  bool isLoading = true;
  bool isErrorOccured = false;

  @override
  void initState() {
    try {
      FirestoreHelper.getUserData().then((value) {
        setState(
          () {
            userData = value;
            isLoading = false;
          },
        );
      }).onError((error, stackTrace) {
        setState(() {
          isErrorOccured = true;
        });
      });
    } catch (e) {
      setState(() {
        isErrorOccured = true;
      });
    }
    //print("||||||||" + isErrorOccured.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (() {
      // your code here
      if (isLoading == true) {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.blueGrey,
            strokeWidth: 2,
          ),
        );
      } else {
        return (userData.id == "")
            ? LoginPage()
            : (MultiProvider(
                providers: [
                    ChangeNotifierProvider<MessageRoomProvider>(
                      create: ((context) => MessageRoomProvider(userData)),
                    )
                  ],
                child: Scaffold(
                  body: HomeScreen(),
                )));
      }
    }());
  }
}
//return userData.id == ""
//        ? Scaffold(body: Center(child: LoginPage()))
//        : (MultiProvider(
//            providers: [
//                ChangeNotifierProvider<MessageRoomProvider>(
//                  create: ((context) => MessageRoomProvider(userData)),
//                )
//              ],
//            child: Scaffold(
//              body: HomeScreen(),
//            )));