import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_input_field.dart';
import 'message.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.messageRoomData}) : super(key: key);
  final MessageRoom messageRoomData;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<bool> updateStatusOfMessages() async {
    try {
      FirestoreHelper.getUserData().then((value) async {
        await FirestoreHelper.db
            .collection('messages')
            .doc(widget.messageRoomData.id)
            .collection('chatMessages')
            .where("status", isEqualTo: 0)
            .where("messageOwnerMail", isNotEqualTo: value.email)
            .get()
            .then((value) {
          value.docs.forEach((element) async {
            await element.reference.update({"status": 1});
          });
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    updateStatusOfMessages().then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .doc(widget.messageRoomData.id)
                      .collection('chatMessages')
                      .orderBy("timeToSent", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView.builder(
                        reverse: true,
                        itemCount:
                            snapshot.data != null ? snapshot.data?.size : 0,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];

                          return Message(
                              messageRoomID: widget.messageRoomData.id,
                              message: ChatMessage(
                                doc.id,
                                doc['message'],
                                doc["messageOwnerMail"],
                                doc["messageOwnerUsername"],
                                doc["timeToSent"].toDate(),
                                ChatMessageType.values[doc["messageType"]],
                                MessageStatus.values[doc["status"]],
                                doc["isAccepted"],
                              ));
                        });
                  })),
        ),
        ChatInputField(
          messageRoom: widget.messageRoomData,
        ),
      ],
    );
  }
}
