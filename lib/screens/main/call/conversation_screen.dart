import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/managers/call_manager.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/platform_utils.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:universal_io/io.dart';

class ConversationCallScreen extends StatefulWidget {
  final P2PSession _callSession;
  final bool _isIncoming;

  @override
  State<StatefulWidget> createState() {
    return _ConversationCallScreenState(_callSession, _isIncoming);
  }

  ConversationCallScreen(this._callSession, this._isIncoming);
}

class _ConversationCallScreenState extends State<ConversationCallScreen>
    implements RTCSessionStateCallback<P2PSession> {
  static const String TAG = "_ConversationCallScreenState";
  final P2PSession _callSession;
  final bool _isIncoming;
  bool _isCameraEnabled = true;
  bool _isSpeakerEnabled = true;
  bool _isMicMute = false;

  RTCVideoRenderer? localRenderer;
  Map<int?, RTCVideoRenderer> remoteRenderers = {};

  bool _enableScreenSharing;

  MediaStream? _localMediaStream;

  bool _isSafari = false;

  Widget? _localVideoView;

  bool _needRebuildLocalVideoView = true;

  bool _customMediaStream = false;

  _ConversationCallScreenState(this._callSession, this._isIncoming)
      : _enableScreenSharing = !_callSession.startScreenSharing;

  @override
  Future<void> dispose() async {
    super.dispose();

    stopBackgroundExecution();

    localRenderer?.srcObject = null;
    localRenderer?.dispose();

    remoteRenderers.forEach((opponentId, renderer) {
      log("[dispose] dispose renderer for $opponentId", TAG);
      try {
        renderer.srcObject = null;
        renderer.dispose();
      } catch (e) {
        log('Error $e');
      }
    });
  }

  Future<void> _addLocalMediaStream(MediaStream stream) async {
    log("_addLocalMediaStream", TAG);

    _localMediaStream = stream;

    if (!mounted) return;

    setState(() {
      _needRebuildLocalVideoView = _isSafari || localRenderer == null;
    });

    /// workaround for updating localVideo in Safari browser
    if (_isSafari) {
      if (!_customMediaStream) {
        _customMediaStream = true;

        var customMediaStream = _enableScreenSharing
            ? await navigator.mediaDevices
                .getUserMedia({'audio': true, 'video': _isVideoCall()})
            : await navigator.mediaDevices
                .getDisplayMedia({'audio': true, 'video': true});

        _callSession.replaceMediaStream(customMediaStream);
        setState(() {
          _needRebuildLocalVideoView = true;
        });
      }
    } else {
      localRenderer?.srcObject = _localMediaStream;
    }
  }

  void _addRemoteMediaStream(session, int userId, MediaStream stream) {
    log("_addRemoteMediaStream for user $userId", TAG);
    _onRemoteStreamAdd(userId, stream);
  }

  Future<void> _removeMediaStream(callSession, int userId) async {
    log("_removeMediaStream for user $userId", TAG);
    RTCVideoRenderer? videoRenderer = remoteRenderers[userId];
    if (videoRenderer == null) return;

    videoRenderer.srcObject = null;
    videoRenderer.dispose();

    setState(() {
      remoteRenderers.remove(userId);
    });
  }

  void _onSessionClosed(session) {
    log("_onSessionClosed", TAG);
    _callSession.removeSessionCallbacksListener();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }

  void _onRemoteStreamAdd(int opponentId, MediaStream stream) async {
    log("_onStreamAdd for user $opponentId", TAG);

    RTCVideoRenderer streamRender = RTCVideoRenderer();
    await streamRender.initialize();
    streamRender.srcObject = stream;
    setState(() {
      remoteRenderers[opponentId] = streamRender;
      _needRebuildLocalVideoView = _isSafari;
    });
  }

  Future<Widget> _buildLocalVideoItem() async {
    log("buildLocalVideoStreamItem", TAG);
    if (localRenderer == null || _isSafari) {
      localRenderer = RTCVideoRenderer();
      await localRenderer!.initialize();
    }

    localRenderer?.srcObject = _localMediaStream;

    _localVideoView = Expanded(
        child: RTCVideoView(
      localRenderer!,
      objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      mirror: true,
    ));
    _needRebuildLocalVideoView = false;

    return _localVideoView!;
  }

  List<Widget> renderStreamsGrid(Orientation orientation) {
    List<Widget> streamsExpanded = [];

    if (_localMediaStream != null) {
      streamsExpanded.add(_isSafari || _localVideoView == null
          ? FutureBuilder<Widget>(
              future: _needRebuildLocalVideoView
                  ? _buildLocalVideoItem()
                  : Future.value(_localVideoView),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Expanded(child: Container());
                }
              })
          : _localVideoView != null
              ? _localVideoView!
              : Expanded(child: Container()));
    }

    streamsExpanded.addAll(remoteRenderers.entries
        .map(
          (entry) => Expanded(
            child: RTCVideoView(
              entry.value,
              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              mirror: false,
            ),
          ),
        )
        .toList());

    if (streamsExpanded.length > 2) {
      List<Widget> rows = [];

      for (var i = 0; i < streamsExpanded.length; i += 2) {
        var chunkEndIndex = i + 2;

        if (streamsExpanded.length < chunkEndIndex) {
          chunkEndIndex = streamsExpanded.length;
        }

        var chunk = streamsExpanded.sublist(i, chunkEndIndex);

        rows.add(
          Expanded(
            child: orientation == Orientation.portrait
                ? Row(children: chunk)
                : Column(children: chunk),
          ),
        );
      }

      return rows;
    }

    return streamsExpanded;
  }

  User callingUser = emptyUser;
  Future getCallingUser() async {
    print(widget._callSession.opponentsIds.toString());
    await FirestoreHelper.getSpecificUserInfoByCubeId(
            widget._callSession.opponentsIds.first)
        .then((value) {
      setState(() {
        callingUser = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCallingUser().then((value) => null);
    _callSession.onLocalStreamReceived = _addLocalMediaStream;
    _callSession.onRemoteStreamReceived = _addRemoteMediaStream;
    _callSession.onSessionClosed = _onSessionClosed;

    _callSession.setSessionCallbacksListener(this);

    if (_isIncoming) {
      _callSession.acceptCall();
    } else {
      _callSession.startCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        body: Stack(fit: StackFit.loose, clipBehavior: Clip.none, children: [
          _isVideoCall()
              ? OrientationBuilder(
                  builder: (context, orientation) {
                    return Center(
                      child: Container(
                        child: orientation == Orientation.portrait
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: renderStreamsGrid(orientation))
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: renderStreamsGrid(orientation)),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          "Audio call",
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          "Calling:",
                          style: TextStyle(
                              fontSize: 20, fontStyle: FontStyle.italic),
                        ),
                      ),
                      Text(
                        callingUser.firstName + " " + callingUser.lastName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _getActionsPanel(),
          ),
        ]),
      ),
    );
  }

  Widget _getActionsPanel() {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32)),
        child: Container(
          padding: EdgeInsets.all(4),
          color: Colors.black26,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "Mute",
                  child: Icon(
                    Icons.mic,
                    color: _isMicMute ? Colors.grey : Colors.white,
                  ),
                  onPressed: () => _muteMic(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "Speacker",
                  child: Icon(
                    Icons.volume_up,
                    color: _isSpeakerEnabled ? Colors.white : Colors.grey,
                  ),
                  onPressed: () => _switchSpeaker(),
                  backgroundColor: Colors.black38,
                ),
              ),
              Visibility(
                visible: false,
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag: "ToggleScreenSharing",
                    child: Icon(
                      _enableScreenSharing
                          ? Icons.screen_share
                          : Icons.stop_screen_share,
                      color: Colors.white,
                    ),
                    onPressed: () => _toggleScreenSharing(),
                    backgroundColor: Colors.black38,
                  ),
                ),
              ),
              Visibility(
                visible: _enableScreenSharing,
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag: "SwitchCamera",
                    child: Icon(
                      Icons.switch_video,
                      color: _isVideoEnabled() ? Colors.white : Colors.grey,
                    ),
                    onPressed: () => _switchCamera(),
                    backgroundColor: Colors.black38,
                  ),
                ),
              ),
              Visibility(
                visible: _enableScreenSharing,
                child: Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: FloatingActionButton(
                    elevation: 0,
                    heroTag: "ToggleCamera",
                    child: Icon(
                      Icons.videocam,
                      color: _isVideoEnabled() ? Colors.white : Colors.grey,
                    ),
                    onPressed: () => _toggleCamera(),
                    backgroundColor: Colors.black38,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              Padding(
                padding: EdgeInsets.only(left: 0),
                child: FloatingActionButton(
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.red,
                  onPressed: () => _endCall(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _endCall() {
    CallManager.instance.hungUp();
    Navigator.pop(context);
  }

  Future<bool> _onBackPressed(BuildContext context) {
    return Future.value(false);
  }

  _muteMic() {
    setState(() {
      _isMicMute = !_isMicMute;
      _callSession.setMicrophoneMute(_isMicMute);
    });
  }

  _switchCamera() {
    if (!_isVideoEnabled()) return;

    _callSession.switchCamera();
  }

  _toggleCamera() {
    if (!_isVideoCall()) return;

    setState(() {
      _isCameraEnabled = !_isCameraEnabled;
      _callSession.setVideoEnabled(_isCameraEnabled);
    });
  }

  _toggleScreenSharing() async {
    var foregroundServiceFuture = _enableScreenSharing
        ? startBackgroundExecution()
        : stopBackgroundExecution();

    var hasPermissions = await hasBackgroundExecutionPermissions();

    if (!hasPermissions) {
      await initForegroundService();
    }

    foregroundServiceFuture.then((_) {
      _callSession.enableScreenSharing(_enableScreenSharing).then((voidResult) {
        setState(() {
          _enableScreenSharing = !_enableScreenSharing;
        });
      });
    });
  }

  bool _isVideoEnabled() {
    return _isVideoCall() && _isCameraEnabled;
  }

  bool _isVideoCall() {
    return CallType.VIDEO_CALL == _callSession.callType;
  }

  _switchSpeaker() {
    setState(() {
      _isSpeakerEnabled = !_isSpeakerEnabled;
      _callSession.enableSpeakerphone(_isSpeakerEnabled);
    });
  }

  @override
  void onConnectedToUser(P2PSession session, int userId) {
    log("onConnectedToUser userId= $userId");
  }

  @override
  void onConnectionClosedForUser(P2PSession session, int userId) {
    log("onConnectionClosedForUser userId= $userId");
    _removeMediaStream(session, userId);
  }

  @override
  void onDisconnectedFromUser(P2PSession session, int userId) {
    log("onDisconnectedFromUser userId= $userId");
  }
}
