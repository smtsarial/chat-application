import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/main.dart';
import 'package:anonmy/providers/pref_util.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  Future<void> saveData(mail) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userUID", mail);
  }

  @override
  void initState() {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isSigningIn = true;
          });

          User? user = await Authentication.signInWithGoogle(context: context);

          if (user != null) {
            final String uuid = Uuid().v4();
            print("objecttttttttttttttttttt");
            print(user);
            await FirestoreHelper.getSpecificUserInfo(user.email.toString())
                .then((value) async {
              print("object");
              print(value.email);
              if (value.email == "") {
                //initConnectycube();
                await signUp(CubeUser(
                  login: user.uid,
                  email: user.email,
                  fullName: user.displayName,
                  password: uuid,
                )).then((cubeUser) async {
                  await SharedPrefs.saveNewUser(cubeUser);
                  print(cubeUser);
                  Fluttertoast.showToast(msg: "cube signed up ");
                  await FirestoreHelper.addNewUser(
                          "",
                          user.email.toString(),
                          "18",
                          0,
                          user.photoURL.toString(),
                          [],
                          [],
                          "Male",
                          true,
                          DateTime.now(),
                          user.displayName.toString(),
                          "",
                          [],
                          "",
                          [],
                          "basic",
                          user.uid.toString(),
                          uuid.toString(),
                          cubeUser.id)
                      .then((value) async {
                    if (value == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Başarılı Şekilde Kayıt Olundu')),
                      );

                      Fluttertoast.showToast(
                          msg: "Please update your profile!");
                      await saveData(user.uid);
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    } else {
                      Authentication().deleteAccount().whenComplete(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Error occured please try again!')),
                        );
                      });
                    }
                  });
                });
              }
            });
          }

          setState(() {
            _isSigningIn = false;
          });
        },
        child: _isSigningIn
            ? Container(
                padding: EdgeInsets.all(5),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
