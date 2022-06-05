import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/show_image.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:voice_message_package/voice_message_package.dart';

Widget buildReplyMessage(ChatMessage message) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${message.message}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(timeago.format(message.timeToSent),
            style: TextStyle(color: Colors.grey)),
      ],
    );

Widget buildReplyMessageImage(BuildContext context, ChatMessage message) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                print("object");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        showImagePage(image: [message.message]),
                  ),
                );
              },
              child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(message.message)))),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(timeago.format(message.timeToSent),
            style: TextStyle(color: Colors.grey)),
      ],
    );
Widget buildReplyMessageAudio(ChatMessage message) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            VoiceMessage(
              audioSrc: message.message == ""
                  ? "https://firebasestorage.googleapis.com/v0/b/anonmy-22c31.appspot.com/o/Audio_Records%2Faudio1654436445871?alt=media&token=fceffd5e-24ba-4bed-9f43-dc4e2dd23596"
                  : message.message,
              me: true,
              mePlayIconColor: Colors.black,
              contactPlayIconColor: Colors.black,
              meBgColor: PrimaryColor,
              played: false,
              contactBgColor: PrimaryColor,
              contactFgColor: PrimaryColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(timeago.format(message.timeToSent),
            style: TextStyle(color: Colors.grey)),
      ],
    );
Widget buildReplyMessageGIPH(ChatMessage message) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 65, // 45% of total width
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
          ],
        ),
        const SizedBox(height: 8),
        Text(timeago.format(message.timeToSent),
            style: TextStyle(color: Colors.grey)),
      ],
    );
