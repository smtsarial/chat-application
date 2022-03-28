import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/models/user.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  int _count = 0;
  List<MessageRoom> normalMessages = [];

  Stream<QuerySnapshot> messages() {
    var data = FirebaseFirestore.instance
        .collection('messages')
        .where("anonim", isEqualTo: false)
        .where("receiverMail", isEqualTo: "sarialsamet@gmail.com")
        .snapshots();
    return data;
  }


  int get getCounter {
    return _count;
  }

  void incrementCounter() {
    _count += 1;
    notifyListeners();
  }

  Future checkUsername() async {
    await FirebaseFirestore.instance
        .collection('DENEME')
        .snapshots()
        .listen((querySnapshot) {
      _count = querySnapshot.size;
      if (querySnapshot.docChanges == true) {
        print("change detected");
        _count = _count + querySnapshot.size;
      }
    });
  }
}
