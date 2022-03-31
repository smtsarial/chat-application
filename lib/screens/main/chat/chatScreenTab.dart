import 'package:anonmy/screens/main/chat/anon_message_screen.dart';
import 'package:anonmy/screens/main/chat/message_screen.dart';
import 'package:flutter/material.dart';

class TabBarChat extends StatefulWidget {
  const TabBarChat({Key? key}) : super(key: key);

  @override
  State<TabBarChat> createState() => _TabBarChatState();
}

class _TabBarChatState extends State<TabBarChat> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.groups_rounded),
                text: "Messages",
              ),
              Tab(
                icon: Icon(Icons.group_rounded),
                text: "Anon Messages",
              )
            ],
          ),
          body: TabBarView(children: [MessagesPage(), AnonMessagesPage()]),
        ));
  }
}
