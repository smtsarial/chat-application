import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/screens/main/chat/messages/components/reactions/items.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/ifRepliedWidget.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class TextMessage extends StatelessWidget {
  const TextMessage({Key? key, this.message, required this.messageRoomID})
      : super(key: key);

  final ChatMessage? message;
  final String messageRoomID;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.65,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: MediaQuery.of(context).platformBrightness == Brightness.dark
              //    ? Colors.white
              //    : PrimaryColor,
              color: PrimaryColor),
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.75,
            vertical: kDefaultPadding / 2,
          ),
          child: Column(children: [
            message!.isReplied == true
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
                                    message: message!,
                                  ))),
                        ],
                      ),
                    ),
                  )
                : Container(),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(message!.message,
                        overflow: TextOverflow.ellipsis, maxLines: 10),
                  ),
                  Container(
                    child: Text(
                      timeago.format(message!.timeToSent),
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        message!.messageOwnerMail != context.watch<UserProvider>().user.email
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
                          .doc(message!.id)
                          .update({"messageReaction": value});
                    },
                    //selectedReaction: defaultInitialReaction,
                    reactions: reactions,
                    initialReaction: Reaction(
                        icon: Icon(Icons.reddit),
                        value: message!.messageReaction.toString()),
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
