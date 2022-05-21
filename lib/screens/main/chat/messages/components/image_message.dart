import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage(
      {Key? key, required this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage message;
  final String messageRoomID;
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //color: MediaQuery.of(context).platformBrightness == Brightness.dark
          //    ? Colors.white
          //    : PrimaryColor,
          color: PrimaryColor),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding / 2,
        vertical: kDefaultPadding / 2,
      ),
      child: message.messageOwnerMail ==
              context.watch<UserProvider>().user.email
          ? Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(message.message))))
          : message.isAccepted
              ? Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: Theme.of(context).scaffoldBackgroundColor),
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(message.message))))
              : GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('messages')
                        .doc(messageRoomID)
                        .collection('chatMessages')
                        .doc(message.id)
                        .update({"isAccepted": true});
                  },
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)!.clicktoseethepicture),
                  )),
    ));
  }
}
