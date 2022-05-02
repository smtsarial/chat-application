import 'package:meta/meta.dart';

class MessageRoom {
  late String id;
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
  late bool acceptAllMedia;
  late int senderCubeId;
  late int receiverCubeId;

  MessageRoom(
      this.id,
      this.MessageRoomPeople,
      this.senderMail,
      this.senderUsername,
      this.senderProfilePictureUrl,
      this.receiverMail,
      this.receiverProfilePictureUrl,
      this.receiverUsername,
      this.lastMessageTime,
      this.lastMessage,
      this.anonim,
      this.acceptAllMedia,
      this.senderCubeId,
      this.receiverCubeId);
}
