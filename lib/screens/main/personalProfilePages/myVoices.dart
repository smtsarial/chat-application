import 'dart:io';

import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MyVoices extends StatefulWidget {
  const MyVoices({Key? key}) : super(key: key);

  @override
  State<MyVoices> createState() => _MyVoicesState();
}

class _MyVoicesState extends State<MyVoices> {
  bool isPlayingMsg = false,
      isRecording = false,
      isSending = false,
      isAudioMessage = false,
      isLoaded = false;

  User user = emptyUser;
  @override
  void initState() {
    FirestoreHelper.getUserData().then((value) {
      setState(() {
        user = value;
        isLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          centerTitle: true,
          title: Text(AppLocalizations.of(context)!.recordyourvoice),
        ),
        floatingActionButton: Container(
            margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: isRecording ? Colors.white : Colors.black12,
                  spreadRadius: 4)
            ], color: PrimaryColor.withOpacity(1), shape: BoxShape.circle),
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
                          title: Text(AppLocalizations.of(context)!.caution),
                          content: Text(AppLocalizations.of(context)!
                              .doyouwanttosendvoicemessage),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(AppLocalizations.of(context)!.cancel),
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
                              child: Text(AppLocalizations.of(context)!.ok),
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
        body: Column(children: <Widget>[
          isLoaded
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: user.myVoices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                VoiceMessage(
                                  contactPlayIconColor: Colors.black,
                                  audioSrc: user.myVoices[index],
                                  me: true,
                                  mePlayIconColor: Colors.black,
                                  meBgColor: PrimaryColor,
                                  played: false,
                                  contactBgColor: PrimaryColor,
                                  contactFgColor: PrimaryColor,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await removeVoiceMessage(
                                              user.myVoices[index])
                                          .then((value) {
                                        if (value == true) {
                                          FirestoreHelper.getUserData()
                                              .then((value) {
                                            setState(() {
                                              user = value;
                                              isLoaded = true;
                                            });
                                          });
                                        } else {
                                          print("object");
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ));
                      }))
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    color: Colors.blueGrey,
                    strokeWidth: 2,
                  ),
                )
        ]));
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
        'myVoices/audio${DateTime.now().millisecondsSinceEpoch.toString()}');

    ref.putFile(File(recordFilePath)).then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      print(audioMsg);
      await FirestoreHelper.getUserData().then((value) async {
        FirebaseFirestore.instance.collection('users').doc(value.id).update({
          "myVoices": FieldValue.arrayUnion([audioMsg])
        });
      });
      FirestoreHelper.getUserData().then((value) {
        setState(() {
          user = value;
          isLoaded = true;
        });
      });
      return true;
    } else {
      print("Hello");
      return false;
    }
  }

  Future<bool> removeVoiceMessage(String audioMsg) async {
    try {
      await FirestoreHelper.getUserData().then((value) async {
        FirebaseFirestore.instance.collection('users').doc(value.id).update({
          "myVoices": FieldValue.arrayRemove([audioMsg])
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
