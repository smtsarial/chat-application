import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:flutter/material.dart';

class RepliedWidget extends StatefulWidget {
  const RepliedWidget({Key? key, required this.message, required this.chatID})
      : super(key: key);
  final ChatMessage message;
  final String chatID;

  @override
  State<RepliedWidget> createState() => _RepliedWidgetState();
}

class _RepliedWidgetState extends State<RepliedWidget> {
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
      "");

  @override
  void initState() {
    getRepliedMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.message.repliedMessageType) {
      case ChatMessageType.text:
        return buildReplyMessage(replyMessage);
      case ChatMessageType.audio:
        return buildReplyMessageAudio(replyMessage);
      case ChatMessageType.image:
        return buildReplyMessageImage(context, replyMessage);
      case ChatMessageType.video:
        return buildReplyMessage(replyMessage);
      case ChatMessageType.gif:
        return buildReplyMessageGIPH(replyMessage);
      default:
        return SizedBox();
    }
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
            doc["messageReaction"],
          );
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
