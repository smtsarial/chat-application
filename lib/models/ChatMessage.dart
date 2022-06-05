import 'package:anonmy/screens/main/chat/messages/components/message.dart';

enum ChatMessageType { text, audio, image, video, gif, empty }
enum MessageStatus { not_view, viewed }
//enum MessageReaction { empty, Happy, Angry, Inlove, Sad, Surprised, Mad }

class ChatMessage {
  final String id;
  final String message;
  final String messageOwnerMail;
  final String messageOwnerUsername;
  final DateTime timeToSent;
  final ChatMessageType messageType;
  final MessageStatus status;
  final bool isAccepted;
  final bool isReplied;
  final ChatMessageType repliedMessageType;
  final String repliedMessageId;
  final String messageReaction;

  ChatMessage(
      this.id,
      this.message,
      this.messageOwnerMail,
      this.messageOwnerUsername,
      this.timeToSent,
      this.messageType,
      this.status,
      this.isAccepted,
      this.isReplied,
      this.repliedMessageType,
      this.repliedMessageId,
      this.messageReaction);
}

List demeChatMessages = [];
