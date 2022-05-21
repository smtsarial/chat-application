import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/auth/login.dart';
import 'package:anonmy/screens/main/personalProfilePages/YoutubeVideoList.dart';
import 'package:anonmy/screens/main/personalProfilePages/blockedList.dart';
import 'package:anonmy/screens/main/personalProfilePages/myHobbies.dart';
import 'package:anonmy/screens/main/personalProfilePages/myMovieList.dart';
import 'package:anonmy/screens/main/personalProfilePages/mySpotifyList.dart';
import 'package:anonmy/screens/main/personalProfilePages/myVoices.dart';
import 'package:anonmy/screens/main/personalProfilePages/privacypolicy.dart';
import 'package:anonmy/screens/main/personalProfilePages/termofuse.dart';
import 'package:anonmy/screens/main/personalProfilePages/turkishprivacypolicy.dart';
import 'package:anonmy/screens/main/personalProfilePages/profileSetting_screen.dart';
import 'package:anonmy/screens/main/personalProfilePages/turkishtermofuse.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      FirestoreHelper.changeToOfflineStatus;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
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
          title: Text(AppLocalizations.of(context)!.account),
          tiles: [
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.userinfo),
              leading: Icon(Icons.email),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditPage()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.myspotifylist),
              leading: Icon(Icons.music_note),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mySpotifyList()),
                );
              },
            ),
            //SettingsTile(
            //  title: Text(AppLocalizations.of(context)!.myyoutubelist),
            //  leading: Icon(Icons.youtube_searched_for),
            //  onPressed: (context) {
            //    Navigator.push(
            //      context,
            //      MaterialPageRoute(builder: (context) => myYoutubeList()),
            //    );
            //  },
            //),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.myvoices),
              leading: Icon(Icons.record_voice_over_rounded),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyVoices()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.mymovies),
              leading: Icon(Icons.movie_creation),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => myMovieList()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.myhobbies),
              leading: Icon(Icons.sports_tennis),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHobbies()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.myblockedlist),
              leading: Icon(Icons.block),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlockedUsers()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.turkishtermsof),
              leading: Icon(Icons.document_scanner_sharp),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TurkishTermOfUse()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.termofuse),
              leading: Icon(Icons.document_scanner_sharp),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermOfUse()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.turkishcprivacy),
              leading: Icon(Icons.document_scanner_sharp),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TurkishPrivacyPolicyScreen()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.privacypolicy),
              leading: Icon(Icons.document_scanner_sharp),
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.deleteallmessages),
              leading: Icon(Icons.folder_delete_outlined),
              onPressed: (context) {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.caution),
                          content: Text(AppLocalizations.of(context)!
                              .youwillallmessagedataandyocannotretrieveback),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirestoreHelper.getUserData()
                                      .then((value) async {
                                    await FirebaseFirestore.instance
                                        .collection('messages')
                                        .where("MessageRoomPeople",
                                            arrayContains: value.email)
                                        .get()
                                        .then((value) {
                                      value.docs.forEach((element) async {
                                        await FirestoreHelper.db
                                            .collection('messages')
                                            .doc(element.id)
                                            .delete()
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: AppLocalizations.of(context)!
                                                  .addedsuccessfully);
                                        });
                                      });
                                    });
                                  }).then((value) => Navigator.pop(context));
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Text(AppLocalizations.of(context)!.accept),
                            ),
                          ],
                        ));
              },
            ),
            SettingsTile(
              title: Text(AppLocalizations.of(context)!.signout),
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
          title: Text(
            AppLocalizations.of(context)!.usersettings,
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
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.saveinfo,
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
