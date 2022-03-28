import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/models/user.dart';
import 'package:flutter/material.dart';

class MessageRoomProvider with ChangeNotifier {
  late Stream<QuerySnapshot> messages;
  late Stream<QuerySnapshot> anonmessages;

  Future<String?> getUserMail() async {
    return await Authentication().getUser();
  }

  MessageRoomProvider(User userData) {
    messages = FirestoreHelper.messages(userData.email);
    anonmessages = FirestoreHelper.ANONmessages(userData.email);
    notifyListeners();
  }
}
