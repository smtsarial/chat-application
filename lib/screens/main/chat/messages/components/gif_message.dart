import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/ifRepliedWidget.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class GifMessage extends StatelessWidget {
  const GifMessage(
      {Key? key, required this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage message;
  final String messageRoomID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        message.isReplied == true
            ? IntrinsicHeight(
                child: Container(
                  color: Color.fromARGB(80, 80, 80, 80),
                  child: Row(
                    children: [
                      Container(
                        color: Colors.green,
                        width: 4,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: RepliedWidget(
                                chatID: messageRoomID,
                                message: message,
                              ))),
                    ],
                  ),
                ),
              )
            : Container(),
        SizedBox(
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
        ),
      ],
    );
  }
}
