// ignore_for_file: unused_element

import 'dart:async';
import 'package:anonmy/managers/call_manager.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
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

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }


  @override
  void initState() {
    try {
      FirestoreHelper.getUserData().then((value) {
        Timer(Duration(seconds: 3), () {
          setState(
            () {
              userData = value;
              isLoading = false;
            },
          );
        });
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CallManager.instance.init(context);
    return (() {
      if (isLoading == true) {
        return Scaffold(
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.deepPurple,
                highlightColor: Colors.white,
                child: Image.asset(
                  "assets/images/seffaf_renkli.png",
                  height: 150,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          )),
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
