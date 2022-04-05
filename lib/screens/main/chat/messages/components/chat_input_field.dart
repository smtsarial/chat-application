import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key, required this.messageRoom}) : super(key: key);
  final MessageRoom messageRoom;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool sentorNot = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    SizedBox(width: kDefaultPadding / 4),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: kDefaultPadding / 3),
                    sentorNot == false
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                sentorNot = true;
                              });
                              sendMessage(messageController.text).then((value) {
                                messageController.text = "";
                                if (value != true) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Connection lost please refresh this page! and try again!"),
                                  ));
                                } else {
                                  setState(() {
                                    sentorNot = false;
                                  });
                                }
                              });
                            },
                            icon: Icon(Icons.send),
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          )
                        : Container(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.blueGrey,
                              strokeWidth: 3,
                            ),
                            height: 20,
                            width: 20,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> updateLastMessageInfo(String message) async {
    try {
      await FirestoreHelper.getUserData().then((value) async {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(widget.messageRoom.id)
            .update({"lastMessage": message, "lastMessageTim": DateTime.now()});
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendMessage(String message) async {
    try {
      await updateLastMessageInfo(message).then((value) async {
        if (value == true) {
          await FirestoreHelper.getUserData().then((value) async {
            await FirestoreHelper.db
                .collection('messages')
                .doc(widget.messageRoom.id)
                .collection('chatMessages')
                .add({
              "messageOwnerMail": value.email,
              "messageOwnerUsername": value.username,
              "timeToSent": DateTime.now(),
              "messageType": 0,
              "status": 0,
              "message": message
            });
          });
          return true;
        } else {
          return false;
        }
      });

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
