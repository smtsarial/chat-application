import 'package:meta/meta.dart';

class MessageRoom {
  late String senderMail;
  late String senderUsername;
  late String senderProfilePictureUrl;
  late String receiverMail;
  late String receiverUsername;
  late String receiverProfilePictureUrl;
  late DateTime lastMessageTime;
  late String lastMessage;
  late List MessageRoomPeople;
  late bool anonim;

  MessageRoom(
      this.MessageRoomPeople,
      this.senderMail,
      this.senderUsername,
      this.senderProfilePictureUrl,
      this.receiverMail,
      this.receiverProfilePictureUrl,
      this.receiverUsername,
      this.lastMessageTime,
      this.lastMessage,
      this.anonim);
}

class MessageData {
  late String senderName;
  late String message;
  late DateTime messageDate;
  late String profilePicture;

  MessageData(
      this.message, this.messageDate, this.profilePicture, this.senderName);
}
