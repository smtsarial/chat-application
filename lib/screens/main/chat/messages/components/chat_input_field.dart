import 'dart:io';

import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/ChatMessage.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/screens/main/chat/messages/components/message.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key, required this.messageRoom}) : super(key: key);
  final MessageRoom messageRoom;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late File _image = File("");
  bool _imageload = false;
  late ImagePicker picker;
  bool sentorNot = false;
  bool _gifloaded = false;
  late String _giflink;
  bool isPlayingMsg = false,
      isRecording = false,
      isSending = false,
      isAudioMessage = false;

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    SizedBox(width: kDefaultPadding / 4),
                    _imageload == true
                        ? Expanded(
                            child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: Image.file(
                                  _image,
                                  fit: BoxFit.cover,
                                ).image,
                                child: IconButton(
                                  icon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    setState(() {
                                      _imageload = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ))
                        : Expanded(
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                hintText: "Type message",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                    IconButton(
                      onPressed: () async {
                        final gif = await ModalGifPicker.pickModalSheetGif(
                          context: context,
                          apiKey: 'TyardCfj6AlrGXaPKYwbV493gvskn5EU',
                          rating: GiphyRating.r,
                          sticker: true,
                          backDropColor: Colors.black,
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          topDragColor: Colors.white.withOpacity(0.2),
                        );
                        if (gif != null) {
                          setState(() {
                            _gifloaded = true;
                            _giflink = gif.embedUrl.toString();
                          });
                          await updateLastMessageInfo("GIF")
                              .then((value) async {
                            if (value == true) {
                              await FirestoreHelper.getUserData()
                                  .then((value) async {
                                await FirestoreHelper.db
                                    .collection('messages')
                                    .doc(widget.messageRoom.id)
                                    .collection('chatMessages')
                                    .add({
                                  "messageOwnerMail": value.email,
                                  "messageOwnerUsername": value.username,
                                  "timeToSent": DateTime.now(),
                                  "messageType": 4,
                                  "status": 0,
                                  "message": gif.id,
                                  "isAccepted": false
                                });
                              });
                              return true;
                            } else {
                              return false;
                            }
                          });
                        }
                      },
                      icon: Icon(
                        Icons.gif_rounded,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        SelectImageFromGallery();
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                    Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: isRecording
                                      ? Colors.white
                                      : Colors.black12,
                                  spreadRadius: 4)
                            ],
                            color: PrimaryColor.withOpacity(1),
                            shape: BoxShape.circle),
                        child: GestureDetector(
                          onLongPress: () {
                            startRecord();
                            setState(() {
                              isRecording = true;
                              isAudioMessage = true;
                            });
                          },
                          onLongPressEnd: (details) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .caution),
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .doyouwanttosendvoicemessage),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await stopRecord().whenComplete(
                                              () => Navigator.pop(context),
                                            );
                                            setState(() {
                                              isRecording = false;
                                            });
                                          },
                                          child: Text(
                                              AppLocalizations.of(context)!.ok),
                                        ),
                                      ],
                                    ));
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 20,
                              )),
                        )),
                    Container(
                      decoration: BoxDecoration(
                          color: PrimaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: sentorNot == false
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  sentorNot = true;
                                });
                                sendMessage(messageController.text)
                                    .then((value) {
                                  messageController.text = "";
                                  if (value != true) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Connection lost please refresh this page! and try again!"),
                                    ));
                                  } else {
                                    setState(() {
                                      sentorNot = false;
                                      _image = File("path");
                                      _imageload = false;
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            )
                          : Container(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.blueGrey,
                                strokeWidth: 3,
                              ),
                              height: 20,
                              width: 20,
                            ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Audio record part
  String recordFilePath = "";

  Future stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  void startRecord() async {
    // bool hasPermission = await checkPermission();
    //if (hasPermission) {
    recordFilePath = await getFilePath();

    RecordMp3.instance.start(recordFilePath, (type) {
      setState(() {});
    });
    //} else {}
    //setState(() {});
  }

  Future<String> getFilePath() async {
    int i = 0;
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/Audio_Records";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/anonmyChat_${i++}.mp3";
  }

  uploadAudio() {
    firebase_storage.Reference ref = FirebaseStorage.instance.ref().child(
        'Audio_Records/audio${DateTime.now().millisecondsSinceEpoch.toString()}');

    ref.putFile(File(recordFilePath)).then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      print(audioMsg);
      await FirestoreHelper.getUserData().then((value) async {
        await FirestoreHelper.db
            .collection('messages')
            .doc(widget.messageRoom.id)
            .collection('chatMessages')
            .add({
          "messageOwnerMail": value.email,
          "messageOwnerUsername": value.username,
          "timeToSent": DateTime.now(),
          "messageType": 1,
          "status": 0,
          "message": audioMsg,
          "isAccepted": false,
        });
      });
    } else {
      print("Hello");
    }
  }

  Future SelectImageFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          _imageload = true;
          _image = File(value.path);
        });
      }
    });
  }

  Future<bool> sendMessage(String message) async {
    try {
      print("asfasfasfasfa");
      print(_image);
      if (_imageload == true) {
        await FirestoreHelper.uploadChatImagesToStorage(_image)
            .then((imageURL) async {
          await updateLastMessageInfo("Photo").then((value1) async {
            if (value1 == true) {
              await FirestoreHelper.getUserData().then((value) async {
                await FirestoreHelper.db
                    .collection('messages')
                    .doc(widget.messageRoom.id)
                    .collection('chatMessages')
                    .add({
                  "messageOwnerMail": value.email,
                  "messageOwnerUsername": value.username,
                  "timeToSent": DateTime.now(),
                  "messageType": 2,
                  "status": 0,
                  "message": imageURL,
                  "isAccepted": false,
                });
              });
              return true;
            } else {
              return false;
            }
          });
        });
      } else {
        if (message.length != 0) {
          await updateLastMessageInfo(message).then((value) async {
            if (value == true) {
              await FirestoreHelper.getUserData().then((value) async {
                await FirestoreHelper.db
                    .collection('messages')
                    .doc(widget.messageRoom.id)
                    .collection('chatMessages')
                    .add({
                  "messageOwnerMail": value.email,
                  "messageOwnerUsername": value.username,
                  "timeToSent": DateTime.now(),
                  "messageType": 0,
                  "status": 0,
                  "message": message,
                  "isAccepted": false,
                });
              });
              return true;
            } else {
              return false;
            }
          });
        }
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateLastMessageInfo(String message) async {
    try {
      await FirestoreHelper.getUserData().then((value) async {
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(widget.messageRoom.id)
            .update(
                {"lastMessage": message, "lastMessageTime": DateTime.now()});
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
