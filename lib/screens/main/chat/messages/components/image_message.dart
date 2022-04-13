import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.white
            : PrimaryColor,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
        vertical: kDefaultPadding / 2,
      ),
      child: Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: Theme.of(context).scaffoldBackgroundColor),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(message.message)))),
    ));
  }
}
