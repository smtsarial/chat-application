import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/MessageRoomProvider.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/messages/chat_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageRoomProvider messageStream = context.watch<MessageRoomProvider>();
    return Column(
      children: [
        Container(
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  "Conversations",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: PrimaryColor, width: 12.0),
                          borderRadius: BorderRadius.circular(5.0)),
                    )),
              ),
              Divider(),
            ],
          )),
        ),
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
          stream: messageStream.messages,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  color: Colors.blueGrey,
                  strokeWidth: 2,
                ),
              );
            return snapshot.requireData.size != 0
                ? new ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      if (document['senderMail'] ==
                          context.watch<UserProvider>().user.email.toString()) {
                        return _MessageTitle(
                            messageData: MessageRoom(
                                document.id,
                                [],
                                document["senderMail"],
                                document["senderUsername"],
                                document["senderProfilePictureUrl"],
                                document["receiverMail"],
                                document["receiverProfilePictureUrl"],
                                document["receiverUsername"],
                                document['lastMessageTime'].toDate(),
                                document['lastMessage'],
                                false));
                      } else if (document['receiverMail'] ==
                          context.watch<UserProvider>().user.email.toString()) {
                        return _MessageTitleReceiver(
                            messageData: MessageRoom(
                                document.id,
                                [],
                                document["senderMail"],
                                document["senderUsername"],
                                document["senderProfilePictureUrl"],
                                document["receiverMail"],
                                document["receiverProfilePictureUrl"],
                                document["receiverUsername"],
                                document['lastMessageTime'].toDate(),
                                document['lastMessage'],
                                false));
                      } else {
                        return Text(
                            "There is no Anon message please check shuffle page");
                      }
                    }).toList(),
                  )
                : (Center(
                    child: Text(
                      "There is no message please check shuffle page to send message.",
                      textAlign: TextAlign.center,
                    ),
                  ));
          },
        ))
      ],
    );
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageRoom messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MessagesScreen()));
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    Avatar.medium(url: messageData.receiverProfilePictureUrl),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messageData.receiverUsername,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      DateFormat('yMd')
                          .format(messageData.lastMessageTime)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLigth,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessageTitleReceiver extends StatelessWidget {
  const _MessageTitleReceiver({
    Key? key,
    required this.messageData,
  }) : super(key: key);

  final MessageRoom messageData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MessagesScreen()));
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.medium(url: messageData.senderProfilePictureUrl),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        messageData.senderUsername,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: Text(
                        messageData.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      DateFormat('yMd')
                          .format(messageData.lastMessageTime)
                          .toString(),
                      style: const TextStyle(
                        fontSize: 11,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaded,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '1',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textLigth,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
