import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/connections/local_notification_api.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/pref_util.dart';
import 'package:anonmy/screens/main/chat/anon_message_screen.dart';
import 'package:anonmy/screens/main/chat/message_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabBarChat extends StatefulWidget {
  const TabBarChat({Key? key}) : super(key: key);

  @override
  State<TabBarChat> createState() => _TabBarChatState();
}

class _TabBarChatState extends State<TabBarChat> {
  _loginToCC(BuildContext context, CubeUser user) {
    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession!.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        print("hello");
        //_goSelectOpponentsScreen(context, user);
      } else {
        _loginToCubeChat(context, user);
      }
    } else {
      createSession(user).then((cubeSession) {
        _loginToCubeChat(context, user);
      }).catchError((exception) {
        _processLoginError(exception);
      });
    }
  }

  void _loginToCubeChat(BuildContext context, CubeUser user) {
    FirestoreHelper.getUserData().then((value) {
      print("********************/***************************"+value.email);
      CubeChatConnection.instance
          .login(CubeUser(
              id: value.cubeid,
              login: value.username,
              fullName: value.firstName + " " + value.lastName,
              password: value.videoServicePassword))
          .then((cubeUser) {
        print(cubeUser);
        SharedPrefs.saveNewUser(user);
      }).catchError((exception) {
        _processLoginError(exception);
      });
    });
  }

  void _processLoginError(exception) {
    log("Login error $exception");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text("Something went wrong during login to ConnectyCube"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    //initConnectycube();
    SharedPrefs.getUser().then((loggedUser) {
      if (loggedUser != null) {
        _loginToCC(context, loggedUser);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.groups_rounded,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                text: AppLocalizations.of(context)!.messages,
              ),
              Tab(
                icon: Icon(Icons.group_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
                text: AppLocalizations.of(context)!.anonmessages,
              )
            ],
          ),
          body: TabBarView(children: [MessagesPage(), AnonMessagesPage()]),
        ));
  }
}
