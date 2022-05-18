import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/managers/call_manager.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';

class IncomingCallScreen extends StatefulWidget {
  static const String TAG = "IncomingCallScreen";
  final P2PSession _callSession;

  IncomingCallScreen(this._callSession);

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  User callingUser = emptyUser;

  Future getCallingUser() async {
    print(widget._callSession.callerId.toString());
    await FirestoreHelper.getSpecificUserInfoByCubeId(
            widget._callSession.callerId)
        .then((value) {
      setState(() {
        callingUser = value;
      });
    });
  }

  @override
  void initState() {
    getCallingUser().then((value) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._callSession.onSessionClosed = (callSession) {
      log("_onSessionClosed", IncomingCallScreen.TAG);
      Navigator.pop(context);
    };

    return WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: Scaffold(
            body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(36),
                child: Text(_getCallTitle(), style: TextStyle(fontSize: 28)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 36, bottom: 8),
                child: Text("Members:", style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 86),
                child: Text(callingUser.firstName + " " + callingUser.lastName,
                    style: TextStyle(fontSize: 18)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 36),
                    child: FloatingActionButton(
                      heroTag: "RejectCall",
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () =>
                          _rejectCall(context, widget._callSession),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: FloatingActionButton(
                      heroTag: "AcceptCall",
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green,
                      onPressed: () =>
                          _acceptCall(context, widget._callSession),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }

  _getCallTitle() {
    var callType;

    switch (widget._callSession.callType) {
      case CallType.VIDEO_CALL:
        callType = "Video";
        break;
      case CallType.AUDIO_CALL:
        callType = "Audio";
        break;
    }

    return "Incoming $callType call";
  }

  void _acceptCall(BuildContext context, P2PSession callSession) {
    CallManager.instance.acceptCall(callSession.sessionId);
  }

  void _rejectCall(BuildContext context, P2PSession callSession) {
    CallManager.instance.reject(callSession.sessionId);
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }
}
