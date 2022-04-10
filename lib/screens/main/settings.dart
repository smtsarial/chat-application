import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/screens/main/profileSetting_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool lockInBackground = true;
  bool notificationsEnabled = true;
  void signOut(context) async {
    late Authentication auth;
    auth = Authentication();
    await auth.signOut().then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: Text("Account"),
          tiles: [
            SettingsTile(
              title: Text('User Informations'),
              leading: Icon(Icons.email),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPage()),
                );
              },
            ),
            SettingsTile(
              title: Text('Change Password'),
              leading: Icon(Icons.password),
              onPressed: (context) {},
            ),
            SettingsTile(
              title: Text('Sign out'),
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) {
                signOut(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class EmailSettings extends StatefulWidget {
  const EmailSettings({Key? key}) : super(key: key);

  @override
  _EmailSettingsState createState() => _EmailSettingsState();
}

class _EmailSettingsState extends State<EmailSettings> {
  User userData = User("", "", 0, 0, "", [], [], "", true, DateTime.now(), "",
      "", [], "", [], "", "", "", "", []);
  late Authentication auth;

  bool _warningMessage = false;
  late String userDataID;
  String warningMEssageValue = "";
  TextEditingController changedFname = new TextEditingController();
  TextEditingController changedLname = new TextEditingController();

  TextEditingController changedPhone = new TextEditingController();

  @override
  initState() {
    try {
      auth = Authentication();
      FirestoreHelper.getUserData().then((data) {
        print("ASFAF" + userDataID);
        setState(() {
          userData = data;
        });
      });
    } catch (error) {
      print(error);
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "User Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          shadowColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                child: Text(
                  warningMEssageValue,
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                visible: _warningMessage,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.email,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedFname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.firstName,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedLname,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.lastName,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    bottom: 8,
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: changedPhone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: userData.city,
                    ),
                  )),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent])),
                  child: const Center(
                    child: Text(
                      "Save Information",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
