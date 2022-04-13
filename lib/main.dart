import 'package:anonmy/connections/local_notification_api.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late String userUID = "loading";
  late String landingRunned = "true";

  @override
  void initState() {
    super.initState();
    _handleAuthenticatedState().then((value) {
      WidgetsBinding.instance?.addObserver(this);
      FirestoreHelper.getUserData().then((value) {
        FirestoreHelper.ALLMESSAGES(value.email).listen((event) {
          if (event.docChanges.isNotEmpty) {
            FirestoreHelper.db
                .collection('messages')
                .doc(event.docChanges.first.doc.id)
                .collection('chatMessages')
                .orderBy("timeToSent", descending: true)
                .get()
                .then((value1) {
              //print(value1.docChanges.first.doc.id);
              if (value1.docs.first['messageOwnerUsername'] != value.username) {
                NotificationApi.showNotification(
                  title: event.docChanges.first.doc['anonim'] == false
                      ? event.docChanges.first.doc['senderUsername'] ==
                              value.email
                          ? event.docChanges.first.doc['senderUsername'] +
                              " sent message."
                          : event.docChanges.first.doc['receiverUsername'] +
                              " sent message."
                      : "Anon-" + event.docChanges.first.doc.id,
                  body: "Message: " + event.docChanges.first.doc['lastMessage'],
                  payload: event.docChanges.first.doc.id,
                );
              }
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
            home: (() {
              // your code here
              if (landingRunned != "true") {
                if (userUID == "loading") {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  );
                } else if (userUID == "") {
                  return LoginPage();
                } else {
                  return SplashScreen();
                }
              } else {
                LandingScreen();
              }
            }())));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final isBackground = state == AppLifecycleState.paused;
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

  Future<void> _handleAuthenticatedState() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userUID");
    var _landingRunned = sharedPreferences.getString("landingRunned");

    setState(() {
      userUID = _usermail.toString();
      landingRunned = _landingRunned.toString();
    });
  }
}
