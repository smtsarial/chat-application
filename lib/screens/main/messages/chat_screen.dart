import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/messages/components/body.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.messageRoom}) : super(key: key);
  final MessageRoom messageRoom;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late MessageRoom messageRoom;
  @override
  void initState() {
    super.initState();
    setState(() {
      messageRoom = widget.messageRoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MessageRoomProvider>(
            create: ((context) =>
                MessageRoomProvider(context.watch<UserProvider>().user)),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () {
                context.watch<MessageRoomProvider>();
                print("profile");
              },
              child: Row(
                children: [
                  BackButton(),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                        messageRoom.receiverProfilePictureUrl),
                  ),
                  SizedBox(width: kDefaultPadding * 0.75),
                  Center(
                    child: Text(
                      messageRoom.receiverUsername,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Center(
                child: messageRoom.anonim ? Text("You are anon!") : Text(""),
              ),
              SizedBox(width: kDefaultPadding / 2),
            ],
          ),
          body: Body(
            messageRoomData: messageRoom,
          ),
        ));
  }
}
