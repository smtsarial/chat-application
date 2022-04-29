import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : PrimaryColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2,
          ),
          child: Text(message!.message,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 20),
        ),
        Text(timeago.format(message!.timeToSent)),
      ],
    ));
  }
}
