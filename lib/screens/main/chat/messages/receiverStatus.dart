import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReceiverStatus extends StatefulWidget {
  const ReceiverStatus({Key? key, required this.receiverMail})
      : super(key: key);
  final String receiverMail;

  @override
  State<ReceiverStatus> createState() => _ReceiverStatusState();
}

class _ReceiverStatusState extends State<ReceiverStatus> {
  User user = emptyUser;
  @override
  void initState() {
    FirestoreHelper.getSpecificUserInfo(widget.receiverMail).then((value) {
      print(value.age);
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: user.showStatus
          ? user.isActive
              ? Text("Online", style: TextStyle(fontSize: 11))
              : Text(timeago.format(user.lastActiveTime),
                  style: TextStyle(fontSize: 11))
          : SizedBox(),
    );
  }
}
