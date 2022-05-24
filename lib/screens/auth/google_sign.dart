import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            await FirestoreHelper.getSpecificUserInfo(user.email.toString())
                .then((value) async {
              //This part value is User coming from the firebase
              if (value.email == "") {
                //FirestoreHelper.addNewUser(id, email, age, chatCount, profilePictureUrl, followers, followed, gender, isActive, lastActiveTime, firstName, lastName, likes, userBio, userTags, userType, username, videoServicePassword, cubeid)
                await FirestoreHelper.addNewUser(
                        "",
                        user.email.toString(),
                        23,
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
                        user.uid,
                        uuid,
                        0)
                    .then((value) async {
                  if (value == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Başarılı Şekilde Kayıt Olundu')),
                    );

                    Fluttertoast.showToast(msg: "Please update your profile!");
                    await saveData(user.uid);
                    FocusManager.instance.primaryFocus!.unfocus();
                    Navigator.pushReplacement(
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
              } else {
                await saveData(value.id);
                FocusManager.instance.primaryFocus!.unfocus();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SplashScreen()));
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
                        AppLocalizations.of(context)!.signwithgoogle,
                        style: TextStyle(
                          fontSize: 16,
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
