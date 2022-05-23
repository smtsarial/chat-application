import 'dart:convert';

import 'package:anonmy/connections/local_notification_api.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/l10n/l10n.dart';
import 'package:anonmy/managers/call_manager.dart';
import 'package:anonmy/managers/push_notifications_manager.dart';
import 'package:anonmy/providers/platform_utils.dart';
import 'package:anonmy/providers/pref_util.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/consumable_store.dart';
import 'package:anonmy/screens/main/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';

//void main() {
//  runApp(
//    const MaterialApp(home: Purchase()),
//  );
//}

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
  bool appOpened = false;
  bool isBackground = false;

  _loginToCC(BuildContext context, CubeUser user) {
    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession!.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        //_goSelectOpponentsScreen(context, user);
      } else {
        _loginToCubeChat(context, user);
      }
    } else {
      createSession(user).then((cubeSession) {
        _loginToCubeChat(context, user);
      }).catchError((exception) {
        _processLoginError(exception, context);
      });
    }
  }

  void _loginToCubeChat(BuildContext context, CubeUser user) {
    FirestoreHelper.getUserData().then((value) {
      print("********************/***************************" + value.email);
      CubeChatConnection.instance
          .login(CubeUser(
              id: value.cubeid,
              login: value.username,
              fullName: value.firstName + " " + value.lastName,
              password: value.videoServicePassword))
          .then((cubeUser) {
        print(cubeUser);
        SharedPrefs.saveNewUser(user);
      }).catchError((exception) {
        _processLoginError(exception, context);
      });
    });
  }

  void _processLoginError(exception,BuildContext context) {
    log("Login error $exception");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text("Something went wrong during login to video service"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Future<void> onBackgroundMessage(RemoteMessage message) {
    log('[onBackgroundMessage] message: $message');
    NotificationApi.showNotification(body: message.data.toString());
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    // request permissions for showing notification in iOS
    firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

    // add listener for foreground push notifications
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      log('[onMessage] message: ' + remoteMessage.data.toString());
      NotificationApi.showNotification(
          body: "Someone calling you!", title: "CALL");
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    initForegroundService();
    FirestoreHelper.getUserData().then((value) {
      SharedPrefs.updateUser(
          CubeUser(id: value.cubeid, password: value.videoServicePassword));
    });
    initConnectycube();
    initForegroundService();
    PushNotificationsManager.instance.init();
    SharedPrefs.getUser().then((loggedUser) {
      if (loggedUser != null) {
        _loginToCC(context, loggedUser);
      }
    });

    //Authentication ---------------------------------------------
    _handleAuthenticatedState().then((value) {
      WidgetsBinding.instance?.addObserver(this);
      FirestoreHelper.getUserData().then((value) {
        FirestoreHelper.ALLMESSAGES(value.email).listen((event) {
          if (event.docChanges.isNotEmpty) {
            if (isBackground == true) {
              FirestoreHelper.db
                  .collection('messages')
                  .doc(event.docChanges.first.doc.id)
                  .collection('chatMessages')
                  .orderBy("timeToSent", descending: true)
                  .get()
                  .then((value1) {
                //print(value1.docChanges.first.doc.id);
                if (value1.docs.first['messageOwnerUsername'] !=
                    value.username) {
                  if (appOpened == false) {
                    NotificationApi.showNotification(
                      title: event.docChanges.first.doc['anonim'] == false
                          ? event.docChanges.first.doc['senderUsername'] ==
                                  value.email
                              ? event.docChanges.first.doc['senderUsername'] +
                                  " sent message."
                              : event.docChanges.first.doc['receiverUsername'] +
                                  " sent message."
                          : "Anon-" + event.docChanges.first.doc.id,
                      body: "Message: " +
                          event.docChanges.first.doc['lastMessage'],
                      payload: event.docChanges.first.doc.id,
                    );
                  }
                }
              });
            }
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
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: (() {
              // your code here
              if (landingRunned != "true") {
                if (userUID == "loading") {
                  return Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.deepPurple,
                      highlightColor: Colors.white,
                      child: Image.asset(
                        "assets/images/seffaf_renkli.png",
                        height: 150,
                      ),
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
    isBackground = state == AppLifecycleState.paused;
    if (isBackground == false) {
      FirestoreHelper.changeUserActiveStatusAndTime(true).then((value) {
        print(value);
        setState(() {
          isBackground = false;
          appOpened = true;
        });
      });
    } else {
      FirestoreHelper.changeUserActiveStatusAndTime(false).then((value) {
        print(value);
        setState(() {
          isBackground = true;
          appOpened = false;
        });
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

initConnectycube() {
  init(
    REGISTERED_APP_ID,
    REGISTERED_AUTH_KEY,
    REGISTERED_AUTH_SECRET,
    onSessionRestore: () {
      return SharedPrefs.getUser().then((savedUser) {
        return createSession(savedUser);
      });
    },
  );
}
