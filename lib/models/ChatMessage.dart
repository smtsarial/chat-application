enum ChatMessageType { text, audio, image, video }
enum MessageStatus { not_view, viewed }

class ChatMessage {
  final String message;
  final String messageOwnerMail;
  final String messageOwnerUsername;
  final DateTime timeToSent;
  final ChatMessageType messageType;
  final MessageStatus status;

  ChatMessage(this.message, this.messageOwnerMail, this.messageOwnerUsername,
      this.timeToSent, this.messageType, this.status);
}

List demeChatMessages = [];
