import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

class ReplyTextMessage extends StatefulWidget {
  const ReplyTextMessage(
      {Key? key, required this.message, required this.notifyCancel})
      : super(key: key);
  final ChatMessage message;
  final Function() notifyCancel;
  @override
  State<ReplyTextMessage> createState() => _ReplyTextMessageState();
}

class _ReplyTextMessageState extends State<ReplyTextMessage> {
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Container(
          color: PrimaryColor,
          child: Row(
            children: [
              Container(
                color: Colors.green,
                width: 4,
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10), child: buildReplyMessage())),
            ],
          ),
        ),
      );

  Widget buildReplyMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.message.message}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                child: Icon(Icons.close, size: 16),
                onTap: widget.notifyCancel,
              )
            ],
          ),
          const SizedBox(height: 8),
          Text("@" + widget.message.messageOwnerUsername,
              style: TextStyle(color: Colors.grey)),
        ],
      );
}
