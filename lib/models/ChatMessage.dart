enum ChatMessageType { text, audio, image, video, gif }
enum MessageStatus { not_view, viewed }

class ChatMessage {
  final String id;
  final String message;
  final String messageOwnerMail;
  final String messageOwnerUsername;
  final DateTime timeToSent;
  final ChatMessageType messageType;
  final MessageStatus status;
  final bool isAccepted;

  ChatMessage(
      this.id,
      this.message,
      this.messageOwnerMail,
      this.messageOwnerUsername,
      this.timeToSent,
      this.messageType,
      this.status,
      this.isAccepted);
}

List demeChatMessages = [];
