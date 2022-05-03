import 'package:anonmy/managers/call_manager.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/chatDetail_screen.dart';
import 'package:anonmy/screens/main/chat/messages/components/body.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
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
    bool isAnonim = widget.messageRoom.anonim;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MessageRoomProvider>(
            create: ((context) =>
                MessageRoomProvider(context.watch<UserProvider>().user)),
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: PrimaryColor,
            automaticallyImplyLeading: false,
            title: GestureDetector(
              onTap: () {
                print("profile");
                messageRoom.anonim == false
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                                  chatRoomInfo: messageRoom,
                                )))
                    : print("anon");
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
                    child: messageRoom.anonim
                        ? messageRoom.senderMail ==
                                context.watch<UserProvider>().user.email
                            ? Text(messageRoom.receiverUsername,
                                style: TextStyle(fontSize: 16))
                            : Text(("anon-" + messageRoom.id).substring(0, 10),
                                style: TextStyle(fontSize: 16))
                        : messageRoom.senderMail ==
                                context.watch<UserProvider>().user.email
                            ? Text(messageRoom.receiverUsername,
                                style: TextStyle(fontSize: 16))
                            : Text(messageRoom.senderUsername,
                                style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: messageRoom.anonim
                    ? messageRoom.senderMail ==
                            context.watch<UserProvider>().user.email
                        ? Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('CAUTION'),
                                              content: const Text(
                                                  'You can not change chat status after this step. Are you sure ?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    try {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'messages')
                                                          .doc(widget
                                                              .messageRoom.id)
                                                          .update({
                                                        "anonim": false
                                                      }).then((value) {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      });
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Text("Get out of anonymity")),
                            ],
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.videocam,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => CallManager.instance
                                      .startNewCall(
                                          context,
                                          CallTypes.VIDEO_CALL,
                                          {messageRoom.senderCubeId}),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => CallManager.instance
                                      .startNewCall(
                                          context,
                                          CallType.AUDIO_CALL,
                                          {messageRoom.senderCubeId}),
                                ),
                              ),
                            ],
                          )
                    : Text(""),
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
