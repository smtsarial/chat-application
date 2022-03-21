import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebasedeneme/connections/auth.dart';
import 'package:firebasedeneme/screens/main/splash_screen.dart';
import 'package:firebasedeneme/theme.dart';
import 'package:firebasedeneme/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
            ),
            CircleAvatar(
              backgroundColor: PureColor,
              radius: 65,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: Image(image: AssetImage('anonuser.png')).image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
            ),
            const Divider(),
            const _SignOutButton(),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends StatefulWidget {
  const _SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  __SignOutButtonState createState() => __SignOutButtonState();
}

class __SignOutButtonState extends State<_SignOutButton> {
  bool _loading = false;

  Future<void> _signOut() async {
    Authentication().signOut().then((value) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userUID", "");
      setState(() {
        _loading = true;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: _signOut,
            child: const Text('Sign out'),
          );
  }
}
