import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMessage extends StatefulWidget {
  final ChatMessage? message;

  const AudioMessage({Key? key, this.message}) : super(key: key);

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
    print("object");
    audioPlayer.setUrl(widget.message!.message);
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() => duration = d.toString().split('.').first.padLeft(8, "0"));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding * 0.75,
        vertical: kDefaultPadding / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kPrimaryColor,
      ),
      child: Row(
        children: [
          isPlaying
              ? GestureDetector(
                  child: Icon(Icons.pause),
                  onTap: () async {
                    setState(() {
                      isPlaying = false;
                    });
                    await stop(widget.message);
                  },
                  //color: message!.isSender ? Colors.white : kPrimaryColor,
                )
              : GestureDetector(
                  child: Icon(Icons.play_arrow),
                  onTap: () async {
                    setState(() {
                      isPlaying = true;
                    });
                    await play(widget.message);
                  },
                  //color: message!.isSender ? Colors.white : kPrimaryColor,
                ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                      width: double.infinity, height: 2, color: Colors.white),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        //color: message!.isSender ? Colors.white : kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(duration,
              style: TextStyle(
                  //fontSize: 12, color: message!.isSender ? Colors.white : null),
                  )),
        ],
      ),
    );
  }

  Future<void> play(ChatMessage? message) async {
    await audioPlayer.play(
      message!.message,
      isLocal: false,
    );
    audioPlayer.onAudioPositionChanged.listen((Duration d) {
      setState(() {
        duration = d.toString().split('.').first.padLeft(8, "0");
      });
    });
    
  }

  Future<void> stop(ChatMessage? message) async {
    await audioPlayer.pause();
  }
}
