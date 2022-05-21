import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:voice_message_package/voice_message_package.dart';

class myVoiceWidget extends StatefulWidget {
  const myVoiceWidget({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<myVoiceWidget> createState() => _myVoiceWidgetState();
}

class _myVoiceWidgetState extends State<myVoiceWidget> {
  bool isLoading = false;
  //User user = emptyUser;
  //@override
  //void initState() {
  //  FirestoreHelper.getUserData().then((value) {
  //    setState(() {
  //      user = value;
  //      isLoading = false;
  //    });
  //  });
  //  super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  "My Voices",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              isLoading
                  ? (Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.deepPurple,
                        highlightColor: Colors.white,
                        child: Image.asset(
                          "assets/images/seffaf_renkli.png",
                          height: 50,
                        ),
                      ),
                    ))
                  : widget.userData.myVoices.length != 0
                      ? (Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.userData.myVoices.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 1, 8, 8),
                                child: SizedBox(
                                  child: VoiceMessage(
                                    audioSrc: widget.userData.myVoices[index],
                                    me: false,
                                    mePlayIconColor: Colors.black,
                                    meBgColor: PrimaryColor,
                                    played: false,
                                    contactBgColor: PrimaryColor,
                                    contactFgColor: PrimaryColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                      : (Container(
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.thereisnohobbie,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: AppColors.textFaded,
                              ),
                            ),
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
