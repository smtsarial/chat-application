import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/reactions/items.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/ifRepliedWidget.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class AudioMessage extends StatefulWidget {
  final ChatMessage message;
  final User userData;
  final String messageRoomID;

  const AudioMessage(
      {Key? key,
      required this.message,
      required this.userData,
      required this.messageRoomID})
      : super(key: key);

  @override
  State<AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<AudioMessage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.message.isReplied == true
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
                                chatID: widget.messageRoomID,
                                message: widget.message,
                              ))),
                    ],
                  ),
                ),
              )
            : Container(),
        Row(
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
              child: Row(
                children: [
                  VoiceMessage(
                    audioSrc: widget.message.message,
                    me: true,
                    mePlayIconColor: Colors.black,
                    meBgColor: PrimaryColor,
                    played: false,
                    contactBgColor: PrimaryColor,
                    contactFgColor: PrimaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            timeago.format(widget.message.timeToSent),
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        widget.message.messageOwnerMail ==
                                context.watch<UserProvider>().user.email
                            ? showReactionIcon(widget.message)
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.message.messageOwnerMail !=
                    context.watch<UserProvider>().user.email
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                    child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ReactionButtonToggle<String>(
                          onReactionChanged:
                              (String? value, bool isChecked) async {
                            debugPrint(
                                'Selected value: $value, isChecked: $isChecked');
                            await FirestoreHelper.db
                                .collection('messages')
                                .doc(widget.messageRoomID)
                                .collection('chatMessages')
                                .doc(widget.message.id)
                                .update({"messageReaction": value});
                          },
                          selectedReaction: initialReaction(widget.message),
                          reactions: reactions,
                          initialReaction: initialReaction(widget.message),
                        )),
                  )
                : SizedBox(),
          ],
        ),
      ],
    );
  }
}
