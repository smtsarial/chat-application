// ignore_for_file: unused_field

import 'dart:io';

import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_gif_picker/modal_gif_picker.dart';

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

  @override
  void initState() {
    super.initState();
    picker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
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
                  horizontal: kDefaultPadding * 0.75,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
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
                        print(gif);
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
                    SizedBox(width: kDefaultPadding / 3),
                    sentorNot == false
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                sentorNot = true;
                              });
                              sendMessage(messageController.text).then((value) {
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
                            icon: Icon(Icons.send),
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.64),
                          )
                        : Container(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              color: Colors.blueGrey,
                              strokeWidth: 3,
                            ),
                            height: 20,
                            width: 20,
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
