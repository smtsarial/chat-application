import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/gif_message.dart';
import 'package:anonmy/screens/main/chat/messages/components/image_message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'audio_message.dart';
import 'text_message.dart';
import 'video_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class Message extends StatefulWidget {
  const Message({Key? key, required this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage message;
  final String messageRoomID;

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessageType.text:
          return TextMessage(message: message);
        case ChatMessageType.audio:
          return AudioMessage(message: message);
        case ChatMessageType.image:
          return ImageMessage(
            message: message,
            messageRoomID: widget.messageRoomID,
          );
        case ChatMessageType.video:
          return VideoMessage(message: message);
        case ChatMessageType.gif:
          return GifMessage(message: message);
        default:
          return SizedBox();
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Row(
        mainAxisAlignment: widget.message.messageOwnerMail ==
                context.watch<UserProvider>().user.email
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (widget.message.messageOwnerMail !=
              context.watch<UserProvider>().user.email) ...[
            SizedBox(width: kDefaultPadding / 2),
          ],
          messageContaint(widget.message),
          if (widget.message.messageOwnerMail ==
              context.watch<UserProvider>().user.email)
            MessageStatusDot(status: widget.message.status)
        ],
      ),
    );
  }
}

class MessageStatusDot extends StatelessWidget {
  final MessageStatus? status;

  const MessageStatusDot({Key? key, this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dotColor(MessageStatus status) {
      switch (status) {
        case MessageStatus.not_view:
          return Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.1);
        case MessageStatus.viewed:
          return kPrimaryColor;
        default:
          return Colors.transparent;
      }
    }

    return Container(
      margin: EdgeInsets.only(left: kDefaultPadding / 2),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        color: dotColor(status!),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.done,
        size: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
