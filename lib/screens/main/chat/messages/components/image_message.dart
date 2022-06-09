import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/screens/main/chat/messages/components/reactions/items.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/ifRepliedWidget.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:anonmy/screens/main/chat/messages/components/show_image.dart';
import 'package:anonmy/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ImageMessage extends StatelessWidget {
  const ImageMessage(
      {Key? key, required this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage message;
  final String messageRoomID;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
            child: Column(
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
                              Container(
                                  padding: EdgeInsets.all(10),
                                  child: RepliedWidget(
                                    chatID: messageRoomID,
                                    message: message,
                                  )),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    message.messageOwnerMail ==
                            context.watch<UserProvider>().user.email
                        ? GestureDetector(
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
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            message.message)))),
                          )
                        : message.isAccepted
                            ? GestureDetector(
                                onTap: () {
                                  print("object");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => showImagePage(
                                          image: [message.message]),
                                    ),
                                  );
                                },
                                child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor),
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                                message.message)))),
                              )
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
                                  child: Text(AppLocalizations.of(context)!
                                      .clicktoseethepicture),
                                )),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              timeago.format(message.timeToSent),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          message.messageOwnerMail ==
                                  context.watch<UserProvider>().user.email
                              ? showReactionIcon(message)
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
        SizedBox(
          height: 5,
        ),
        message.messageOwnerMail != context.watch<UserProvider>().user.email
            ? SizedBox(
                width: MediaQuery.of(context).size.width * .1,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ReactionButtonToggle<String>(
                      onReactionChanged: (String? value, bool isChecked) async {
                        debugPrint(
                            'Selected value: $value, isChecked: $isChecked');
                        await FirestoreHelper.db
                            .collection('messages')
                            .doc(messageRoomID)
                            .collection('chatMessages')
                            .doc(message.id)
                            .update({"messageReaction": value});
                      },
                      selectedReaction: initialReaction(message),
                      reactions: reactions,
                      initialReaction: initialReaction(message),
                    )),
              )
            : SizedBox(),
      ],
    );
  }
}
