import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

class GifMessage extends StatelessWidget {
  const GifMessage({Key? key, required this.message}) : super(key: key);

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
                child: Image.network(
                  ("https://media.giphy.com/media/" +
                      message.message +
                      "/giphy.gif"),
                  height: 100,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
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
    );
  }
}
