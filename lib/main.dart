import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedeneme/screens/main/home_screen.dart';
import 'package:firebasedeneme/screens/main/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:firebasedeneme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'RobotoMono',
      ),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      title: 'anonmy',
      home: SplashScreen(),
    );
  }
}
