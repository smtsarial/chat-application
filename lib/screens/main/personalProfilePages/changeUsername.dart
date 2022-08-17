import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/main.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class changeUsername extends StatefulWidget {
  const changeUsername({Key? key}) : super(key: key);

  @override
  State<changeUsername> createState() => _changeUsernameState();
}

class _changeUsernameState extends State<changeUsername> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  User userData = emptyUser;
  bool _visibleCircular = false;
  bool showMessage = false;

  @override
  void initState() {
    if (mounted) {
      Authentication().getUser().then((value) {
        FirestoreHelper.getUserData()
            .then((value) => setState((() => userData = value)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.changeusername),
        backgroundColor: PrimaryColor,
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Visibility(
                  visible: showMessage,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      AppLocalizations.of(context)!.usernamechangedsuccessfully,
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Visibility(
                  visible: userData.canChangeUsername,
                  child: Text("You can change username only one time",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                child: TextFormField(
                  style: TextStyle(color: TextColor),
                  validator: (value) {
                    if (userData.canChangeUsername) {
                      FirestoreHelper.checkUsername(value).then((value1) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the area!';
                        } else if (value1 != 0) {
                          return "Please enter unique username";
                        }
                      });
                    } else {
                      return "You can't change username";
                    }
                  },
                  controller: usernameController,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: userData.username,
                    hintStyle: TextStyle(color: TextColor),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Visibility(
                  visible: userData.canChangeUsername,
                  child: RaisedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _visibleCircular = true;
                          });
                          try {
                            FirestoreHelper.db
                                .collection('users')
                                .doc(userData.id)
                                .update({
                              "username": usernameController.text
                            }).then((value) {
                              setState(() {
                                _visibleCircular = false;
                                showMessage = true;
                              });
                              FirestoreHelper.db
                                  .collection('users')
                                  .doc(userData.id)
                                  .update({"canChangeUsername": false}).then(
                                      (value) => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyApp()),
                                          ));
                            });
                          } catch (e) {
                            setState(() {
                              _visibleCircular = false;
                            });
                          }
                        }
                      },
                      color: PrimaryColor,
                      child: _visibleCircular
                          ? Visibility(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey,
                                color: Colors.blueGrey,
                                strokeWidth: 2,
                              ),
                              visible: _visibleCircular,
                            )
                          : Text(AppLocalizations.of(context)!.changeusername,
                              style: TextStyle(fontSize: 15))),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Visibility(
                  visible: !userData.canChangeUsername,
                  child: Text("You cannot change username anymore",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              )
            ])),
      ),
    );
  }
}
