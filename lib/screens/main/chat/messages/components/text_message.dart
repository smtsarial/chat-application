import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage? message;
  final String messageRoomID;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            //color: MediaQuery.of(context).platformBrightness == Brightness.dark
            //    ? Colors.white
            //    : PrimaryColor,
            color: PrimaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 0.75,
          vertical: kDefaultPadding / 2,
        ),
        child: Column(children: [
          message!.isReplied == true
              ? IntrinsicHeight(
                  child: Container(
                    color: Color.fromARGB(80, 80, 80, 80),
                    child: Row(
                      children: [
                        Container(
                          color: Colors.green,
                          width: 4,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: _RepliedMessage(
                                  chatID: messageRoomID,
                                  message: message!,
                                ))),
                      ],
                    ),
                  ),
                )
              : Container(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(message!.message,
                      overflow: TextOverflow.ellipsis, maxLines: 10),
                ),
                Container(
                  child: Text(
                    timeago.format(message!.timeToSent),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}

class _RepliedMessage extends StatefulWidget {
  const _RepliedMessage({Key? key, required this.message, required this.chatID})
      : super(key: key);
  final ChatMessage message;
  final String chatID;

  @override
  State<_RepliedMessage> createState() => __RepliedMessageState();
}

class __RepliedMessageState extends State<_RepliedMessage> {
  ChatMessage replyMessage = ChatMessage(
      "",
      "",
      "",
      "",
      DateTime.now(),
      ChatMessageType.values[0],
      MessageStatus.values[1],
      true,
      false,
      ChatMessageType.values[0],
      "",
      MessageReaction.values[0]);

  @override
  void initState() {
    getRepliedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                replyMessage.message,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(timeago.format(replyMessage.timeToSent),
            style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Future getRepliedMessage() async {
    try {
      await FirestoreHelper.db
          .collection('messages')
          .doc(widget.chatID)
          .collection("chatMessages")
          .doc(widget.message.repliedMessageId)
          .get()
          .then((doc) {
        setState(() {
          replyMessage = ChatMessage(
            doc.id,
            doc['message'],
            doc["messageOwnerMail"],
            doc["messageOwnerUsername"],
            doc["timeToSent"].toDate(),
            ChatMessageType.values[doc["messageType"]],
            MessageStatus.values[doc["status"]],
            doc["isAccepted"],
            doc["isReplied"],
            ChatMessageType.values[doc["repliedMessageType"]],
            doc["repliedMessageId"],
            MessageReaction.values[doc["messageReaction"]],
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
