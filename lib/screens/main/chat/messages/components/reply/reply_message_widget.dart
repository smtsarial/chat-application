import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectycube_sdk/connectycube_calls.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:voice_message_package/voice_message_package.dart';

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
                      padding: EdgeInsets.all(10), child: messageContaint())),
            ],
          ),
        ),
      );

  Widget messageContaint() {
    switch (widget.message.messageType) {
      case ChatMessageType.text:
        return buildReplyMessage();
      case ChatMessageType.audio:
        return buildReplyMessageAudio();
      case ChatMessageType.image:
        return buildReplyMessageImage();
      case ChatMessageType.video:
        return buildReplyMessage();
      case ChatMessageType.gif:
        return buildReplyMessageGIPH();
      default:
        return SizedBox();
    }
  }

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
          Text(timeago.format(widget.message.timeToSent),
              style: TextStyle(color: Colors.grey)),
        ],
      );

  Widget buildReplyMessageImage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              widget.message.message)))),
              GestureDetector(
                child: Icon(Icons.close, size: 16),
                onTap: widget.notifyCancel,
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(timeago.format(widget.message.timeToSent),
              style: TextStyle(color: Colors.grey)),
        ],
      );
  Widget buildReplyMessageAudio() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VoiceMessage(
                audioSrc: widget.message.message,
                me: true,
                mePlayIconColor: Colors.black,
                contactPlayIconColor: Colors.black,
                meBgColor: Colors.grey,
                played: false,
                contactBgColor: Colors.grey,
                contactFgColor: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(timeago.format(widget.message.timeToSent),
              style: TextStyle(color: Colors.grey)),
        ],
      );
  Widget buildReplyMessageGIPH() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.45, // 45% of total width
                child: AspectRatio(
                  aspectRatio: 1.6,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            ("https://media.giphy.com/media/" +
                                widget.message.message +
                                "/giphy.gif"),
                            height: 100,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(Icons.close, size: 16),
                onTap: widget.notifyCancel,
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(timeago.format(widget.message.timeToSent),
              style: TextStyle(color: Colors.grey)),
        ],
      );
}
