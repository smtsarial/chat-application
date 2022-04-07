import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45, // 45% of total width
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(message.message)),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: 16,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
