import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key, required this.chatRoomInfo})
      : super(key: key);
  final MessageRoom chatRoomInfo;
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  User RECEIVER = emptyUser;

  List<ChatMessage> messagesInfo = [];
  bool isLoaded = false;
  @override
  void initState() {
    completeInit().whenComplete(() => setState(() {
          isLoaded = true;
        }));
    super.initState();
  }

  Future completeInit() async {
    await FirestoreHelper.getUserData().then((value) async {
      String receiverMail = "";

      if (widget.chatRoomInfo.receiverMail == value.email) {
        receiverMail = widget.chatRoomInfo.senderMail;
      } else {
        receiverMail = widget.chatRoomInfo.receiverMail;
      }
      await FirestoreHelper.db
          .collection('users')
          .where('email', isEqualTo: receiverMail)
          .get()
          .then((value) {
        RECEIVER = User.fromMap(value.docs.first);
      });
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.chatRoomInfo.id)
          .collection('chatMessages')
          .orderBy("timeToSent", descending: true)
          .get()
          .then((doc) {
        List<ChatMessage> chatmessages = [];
        doc.docs.forEach((element) {
          ChatMessage message = ChatMessage(
            element.id,
            element['message'],
            element["messageOwnerMail"],
            element["messageOwnerUsername"],
            element["timeToSent"].toDate(),
            ChatMessageType.values[element["messageType"]],
            MessageStatus.values[element["status"]],
            element["isAccepted"],
          );
          chatmessages.add(message);
        });
        setState(() {
          messagesInfo = chatmessages;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == true
        ? Scaffold(
            appBar: buildAppBar(),
            body: body(context),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: Colors.blueGrey,
                strokeWidth: 2,
              ),
            ),
          );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                RECEIVER.firstName + " " + RECEIVER.lastName,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
      actions: [
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 22,
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.green,
                    ],
                  ),
                  shape: BoxShape.circle,
                  color: PrimaryColor,
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 95,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.chatRoomInfo.receiverProfilePictureUrl),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "@" + RECEIVER.username,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  RECEIVER.country + " " + RECEIVER.city,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  RECEIVER.gender,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  RECEIVER.age.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
          Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      "Total " +
                          messagesInfo.length.toString() +
                          " message sent",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _Stories(
              imageMessages: messagesInfo
                  .where(
                      (element) => element.messageType == ChatMessageType.image)
                  .toList()),
          Container(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: messagesInfo.length != 0
                        ? Text(
                            "Last message sent at " +
                                timeago.format(messagesInfo[0].timeToSent),
                            style: const TextStyle(fontSize: 16),
                          )
                        : Text(
                            "There is no last message",
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                      child: messagesInfo.length != 0
                          ? Message(
                              message: messagesInfo.first,
                              messageRoomID: "",
                            )
                          : Container()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stories extends StatefulWidget {
  const _Stories({Key? key, required this.imageMessages}) : super(key: key);
  final List<ChatMessage> imageMessages;
  @override
  State<_Stories> createState() => _StoriesState();
}

class _StoriesState extends State<_Stories> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  'Photos',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              widget.imageMessages.length != 0
                  ? (Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.imageMessages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 60,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: _StoryCard(
                                      messageData:
                                          widget.imageMessages[index])),
                            ),
                          );
                        },
                      ),
                    ))
                  : (const Center(
                      child: Text(
                        "There is no photo to show",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final ChatMessage messageData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Avatar.medium(url: messageData.message),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              timeago.format(messageData.timeToSent),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
