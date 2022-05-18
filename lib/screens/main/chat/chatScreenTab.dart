import 'package:anonmy/screens/main/chat/anon_message_screen.dart';
import 'package:anonmy/screens/main/chat/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabBarChat extends StatefulWidget {
  const TabBarChat({Key? key}) : super(key: key);

  @override
  State<TabBarChat> createState() => _TabBarChatState();
}

class _TabBarChatState extends State<TabBarChat> {
  @override
  void initState() {
    //initConnectycube();

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
