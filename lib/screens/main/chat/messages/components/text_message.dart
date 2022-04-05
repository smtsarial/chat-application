import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key? key,
    this.message,
  }) : super(key: key);

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(
        message!.message,
        style: TextStyle(
        ),
      ),
    );
  }
}