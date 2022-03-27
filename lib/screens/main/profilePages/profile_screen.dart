import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/helper.dart';
import 'package:firebasedeneme/models/user.dart';
import 'package:firebasedeneme/theme.dart';
import 'package:firebasedeneme/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData.firstName + " " + widget.userData.lastName,
                style: TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
      actions: [
        SizedBox(width: kDefaultPadding / 2),
        Center(
          child: Text("Follow"),
        ),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 22,
          ),
          Center(
            child: CircleAvatar(
                backgroundColor: PureColor,
                radius: 100,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 95,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.userData.profilePictureUrl),
                    ),
                    Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          child: IconButton(
                            icon: Icon(Icons.photo_album_sharp),
                            onPressed: () {},
                          ),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30)),
                        )),
                  ],
                )),
          ),
          SizedBox(
            height: 22,
          ),
          Divider(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      FirestoreHelper.sendMessageNormally(
                          widget.userData.email,
                          widget.userData.username,
                          widget.userData.profilePictureUrl,
                          false);
                    },
                    child: Text("Send Message")),
                TextButton(
                    onPressed: () {
                      FirestoreHelper.sendMessageNormally(
                          widget.userData.email,
                          widget.userData.username,
                          widget.userData.profilePictureUrl,
                          true);
                    },
                    child: Text("Send Message Anonymously"))
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          Divider(),
          userSpecificInformationLayer(),
          Divider(),
          Container(
            child: Text("samet"),
          )
        ],
      ),
    );
  }

  Widget userSpecificInformationLayer() {
    return Center(
      child: Container(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Icon(Icons.message),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Messages",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.userData.chatCount.toString())
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  FaIcon(FontAwesomeIcons.solidThumbsUp),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.userData.followers.length.toString())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
