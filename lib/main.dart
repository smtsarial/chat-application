import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:anonmy/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late String userUID = "";
  Future<void> _handleAuthenticatedState() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userUID");

    setState(() {
      userUID = _usermail.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    _handleAuthenticatedState().then((value) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
    print("*****" + isBackground.toString());
    if (isBackground == false) {
      FirestoreHelper.changeUserActiveStatusAndTime(true).then((value) {
        print(value);
      });
    } else {
      FirestoreHelper.changeUserActiveStatusAndTime(false).then((value) {
        print(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: ((context) => UserProvider()),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.dark,
            title: 'anonmy',
            home: userUID == "" ? LoginPage() : SplashScreen()));
  }
}
