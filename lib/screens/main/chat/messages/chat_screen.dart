import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/body.dart';
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
                print("profile");
              },
              child: Row(
                children: [
                  BackButton(),
                  messageRoom.anonim
                      ? messageRoom.senderMail ==
                              context.watch<UserProvider>().user.email
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  messageRoom.receiverProfilePictureUrl),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  "https://firebasestorage.googleapis.com/v0/b/denemeprojem-65ebc.appspot.com/o/profileImages%2Fanonuser.png?alt=media&token=5e705128-21cf-480a-bd50-36097e98455a"),
                            )
                      : messageRoom.senderMail ==
                              context.watch<UserProvider>().user.email
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  messageRoom.receiverProfilePictureUrl),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: CachedNetworkImageProvider(
                                  messageRoom.senderProfilePictureUrl),
                            ),
                  SizedBox(width: kDefaultPadding * 0.75),
                  Center(
                    child: Text(
                      messageRoom.anonim
                          ? messageRoom.senderMail ==
                                  context.watch<UserProvider>().user.email
                              ? messageRoom.receiverUsername
                              : ("anon-" + messageRoom.id).substring(0, 15)
                          : messageRoom.senderMail ==
                                  context.watch<UserProvider>().user.email
                              ? messageRoom.receiverUsername
                              : messageRoom.senderUsername,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Center(
                child: messageRoom.anonim ? Text("Anon chat!") : Text(""),
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
