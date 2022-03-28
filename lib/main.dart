import 'package:firebase_core/firebase_core.dart';
import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/messages.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/home_screen.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:anonmy/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          home: SplashScreen(),
        ));
  }
}
