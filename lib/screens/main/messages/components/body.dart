import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/theme.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: ListView.builder(
              reverse: true,
              itemCount: demeChatMessages.length,
              itemBuilder: (context, index) =>
                  Message(message: demeChatMessages[index]),
            ),
          ),
        ),
        ChatInputField(
          messageRoom: widget.messageRoomData,
        ),
      ],
    );
  }
}
