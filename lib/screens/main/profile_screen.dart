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
        body: SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 36,
            ),
            Text(
              "SAMET SARIAL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 26,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: IconButton(
                        onPressed: () {}, icon: Icon(Icons.settings)),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.blue,
                          Colors.red,
                        ],
                      ),
                      shape: BoxShape.circle,
                      color: PrimaryColor,
                    ),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: Image(
                              image: NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/denemeprojem-65ebc.appspot.com/o/profileImages%2Fimage_picker8854925666362766770.jpg'?alt=media&token=1440a674-0a91-4bb9-91e7-6c2137132eba"))
                          .image,
                    ),
                  ),
                  Container(
                    child:
                        IconButton(onPressed: () {}, icon: Icon(Icons.logout)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            const Divider(),
            const _SignOutButton(),
          ],
        ),
      ),
    ));
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
