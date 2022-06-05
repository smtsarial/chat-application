import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/ifRepliedWidget.dart';
import 'package:anonmy/screens/main/chat/messages/components/reply/repliedMessageOnNormalMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  bool isPlaying = false;
  String duration = "";
  String maxDuration = "";
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    print(widget.message.message);
    print("object");
    audioPlayer.setUrl(widget.message.message);
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      if (mounted) {
        setState(
            () => duration = d.toString().split('.').first.padLeft(8, "0"));
      }
    });
    super.initState();
  }

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
        VoiceMessage(
          audioSrc: widget.message.message,
          me: widget.message.messageOwnerMail == widget.userData.email
              ? true
              : false,
          mePlayIconColor: Colors.black,
          meBgColor: PrimaryColor,
          played: false,
          contactBgColor: PrimaryColor,
          contactFgColor: PrimaryColor,
        ),
      ],
    );
  }
}
