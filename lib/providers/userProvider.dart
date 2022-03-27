import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/models/message_data.dart';
import 'package:firebasedeneme/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = User("", "", 0, 0, "", [], [], "", true, DateTime.now(), "", "",
      [], "", [], "", "", "", "");

  UserProvider() {
    FirestoreHelper.getUserData().then((value) => user = value);
    notifyListeners();
  }
}
