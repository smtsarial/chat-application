import 'package:anonmy/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User user = emptyUser;

  UserProvider() {
    FirestoreHelper.getUserData().then((value) => user = value);
    notifyListeners();
  }
  void updateUserData() {
    FirestoreHelper.getUserData().then((value) => user = value);
    notifyListeners();
  }

  void signOut() {
    user = emptyUser;
    notifyListeners();
  }
}
