import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/story.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/widgets/QuickHelp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStoriesScreen extends StatefulWidget {
  const MyStoriesScreen({Key? key}) : super(key: key);

  @override
  State<MyStoriesScreen> createState() => _MyStoriesScreenState();
}

class _MyStoriesScreenState extends State<MyStoriesScreen> {
  List<Story> stories = [];
  bool isLoaded = false;
  @override
  void initState() {
    FirestoreHelper.getUserData().then((value) {
      FirestoreHelper.getStoriesForUser(value).then((value) {
        setState(() {
          stories = value;
          isLoaded = true;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.storieslist),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            isLoaded
                ? stories.length == 0
                    ? Center(
                        child: Text(
                            AppLocalizations.of(context)!.thereisnostories))
                    : Expanded(
                        child: stories.isNotEmpty
                            ? ListView.builder(
                                itemCount: stories.length,
                                itemBuilder: (context, position) {
                                  Story item = stories[position];
                                  return Column(
                                    children: [
                                      ListTile(
                                          onTap: () => {},
                                          leading: Container(
                                              height: double.infinity,
                                              child: CircleAvatar(
                                                radius: 70,
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        item.imageUrl),
                                              )),
                                          title: Text(
                                            timeago.format(item.createdTime),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Wrap(
                                            spacing: 12,
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          try {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'stories')
                                                                .doc(item.id)
                                                                .delete()
                                                                .then((value) {
                                                              QuickHelp
                                                                  .showAppNotificationAdvanced(
                                                                context:
                                                                    context,
                                                                title:
                                                                    "Successfully",
                                                                message: AppLocalizations.of(
                                                                        context)!
                                                                    .success,
                                                                isError: false,
                                                              );
                                                              FirestoreHelper
                                                                      .getUserData()
                                                                  .then(
                                                                      (value) {
                                                                FirestoreHelper
                                                                        .getStoriesForUser(
                                                                            value)
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    stories =
                                                                        value;
                                                                  });
                                                                });
                                                              });
                                                            });
                                                          } catch (e) {
                                                            print(e);
                                                            QuickHelp
                                                                .showAppNotificationAdvanced(
                                                              context: context,
                                                              title: "Error",
                                                              message: AppLocalizations
                                                                      .of(context)!
                                                                  .erroroccured,
                                                              isError: true,
                                                            );
                                                          }
                                                        },
                                                        icon: Icon(Icons
                                                            .remove_circle_rounded)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      Divider()
                                    ],
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                    AppLocalizations.of(context)!
                                        .thereisnostories,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ))
                : Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.deepPurple,
                      highlightColor: Colors.white,
                      child: Image.asset(
                        "assets/images/seffaf_renkli.png",
                        height: 150,
                      ),
                    ),
                  )
          ],
        )),
      ),
    );
  }
}
