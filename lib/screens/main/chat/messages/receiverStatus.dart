import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    if (mounted) {
      FirestoreHelper.getSpecificUserInfo(widget.receiverMail).then((value) {
        print(value.age);
        setState(() {
          user = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: user.showStatus
          ? user.isActive
              ? Text(AppLocalizations.of(context)!.online,
                  style: TextStyle(fontSize: 11))
              : Text(timeago.format(user.lastActiveTime),
                  style: TextStyle(fontSize: 11))
          : SizedBox(),
    );
  }
}
