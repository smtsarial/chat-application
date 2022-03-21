import 'package:firebasedeneme/connections/auth.dart';
import 'package:firebasedeneme/screens/main/splash_screen.dart';
import 'package:firebasedeneme/theme.dart';
import 'package:firebasedeneme/screens/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _warningMessage = false;
  String _warningMessageContent = "";
  late Authentication auth;
  TextEditingController newTaskController = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  bool _visibleCircular = false;
  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Text(
          "AnonMy",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );

    final email = TextField(
      style: TextStyle(color: TextColor),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final password = TextField(
      style: TextStyle(color: TextColor),
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(color: TextColor),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 5, 16, 0),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            _visibleCircular = true;
          });
          loginCheck(context);
        },
        padding: EdgeInsets.all(12),
        color: PureColor,
        child: _visibleCircular
            ? Visibility(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
                visible: _visibleCircular,
              )
            : Text('Log In', style: TextStyle(color: PrimaryColor)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterScreen()));
        },
        padding: EdgeInsets.all(12),
        color: PureColor,
        child: Text('Register', style: TextStyle(color: PrimaryColor)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: PureColor),
      ),
      onPressed: () {
        _showMyDialog(context);
      },
    );

    return Scaffold(
      backgroundColor: PrimaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 14.0, right: 14.0),
          children: <Widget>[
            logo,
            SizedBox(height: 8.0),
            Visibility(
              child: Center(
                  child: Text(
                _warningMessageContent,
                style: TextStyle(
                  color: PureColor,
                  fontWeight: FontWeight.bold,
                ),
              )),
              visible: _warningMessage,
            ),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            registerButton,
            forgotLabel
          ],
        ),
      ),
    );
  }

  Future<void> saveData(mail) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("userUID", mail);
  }

  Future loginCheck(context) async {
    if (passwordController.text.isEmpty && emailController.text.isEmpty) {
      setState(() {
        _warningMessage = true;
        _warningMessageContent = "Please fill all fields!";

        _visibleCircular = false;
      });
    } else {
      late String _userEmail = "";
      try {
        _userEmail =
            await auth.login(emailController.text, passwordController.text);

        await saveData(_userEmail.toString());
        FocusManager.instance.primaryFocus!.unfocus();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
      } catch (err) {
        setState(() {
          _warningMessage = true;
          _warningMessageContent = "Your information wrong";

          _visibleCircular = false;
        });
      }
    }
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: PrimaryColor,
          title: Text(
            'Password Reset',
            style: TextStyle(color: TextColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: TextFormField(
                            style: TextStyle(color: TextColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill the area!';
                              }
                              return null;
                            },
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              hintStyle: TextStyle(color: TextColor),
                              contentPadding:
                                  EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
                            ),
                            controller: newTaskController,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: PureColor,
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey1.currentState!.validate()) {
                  Authentication()
                      .resetPassword(newTaskController.text)
                      .then((value) {
                    if (value == true) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password reset mail sent to " +
                            newTaskController.text),
                      ));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error occured while sending email!"),
                      ));
                      Navigator.pop(context);
                    }
                  });
                }
              },
              child: const Text(
                'Send Reset Mail',
                style: TextStyle(color: PrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
