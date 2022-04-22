import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/profilePages/YoutubeVideoList.dart';
import 'package:anonmy/screens/main/profilePages/myHobbies.dart';
import 'package:anonmy/screens/main/profilePages/myMovieList.dart';
import 'package:anonmy/screens/main/profilePages/mySpotifyList.dart';
import 'package:anonmy/screens/main/profilePages/profileSetting_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> _signOut() async {
    Authentication().signOut().then((value) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userUID", "");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
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
        backgroundColor: PrimaryColor,
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
              title: Text('My Spotify List'),
              leading: Icon(Icons.music_note),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mySpotifyList()),
                );
              },
            ),
            SettingsTile(
              title: Text('My Youtube List'),
              leading: Icon(Icons.youtube_searched_for),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myYoutubeList()),
                );
              },
            ),
            SettingsTile(
              title: Text('My Movie List'),
              leading: Icon(Icons.movie_creation),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myMovieList()),
                );
              },
            ),
            SettingsTile(
              title: Text('My Hobbie List'),
              leading: Icon(Icons.sports_tennis),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHobbies()),
                );
              },
            ),
            SettingsTile(
              title: Text('Sign out'),
              leading: Icon(Icons.exit_to_app),
              onPressed: (context) {
                _signOut();
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
  User userData = emptyUser;
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
