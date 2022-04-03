import 'package:anonmy/models/message_data.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/chat/messages/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/helper.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.senderData, required this.userData})
      : super(key: key);
  final User userData;
  final User senderData;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool follower = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      follower = widget.userData.followers.contains(widget.senderData.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: body(context),
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
            child: widget.userData.followers
                    .contains(widget.senderData.username)
                ? GestureDetector(
                    child: Text("Unfollow"),
                    onTap: () {
                      FirestoreHelper.unfollowUser(
                              widget.userData, widget.senderData)
                          .then((value) {
                        if (value == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('You unfollowed ' +
                                    widget.userData.firstName.toString() +
                                    " " +
                                    widget.userData.lastName)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Error occured please try again!')),
                          );
                        }
                      });
                    },
                  )
                : GestureDetector(
                    child: Text("Follow"),
                    onTap: () {
                      FirestoreHelper.addFollowersToUser(
                              widget.senderData, widget.userData)
                          .then((value) {
                        if (value == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('You followed ' +
                                    widget.userData.firstName.toString() +
                                    " " +
                                    widget.userData.lastName)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Error occured please try again!')),
                          );
                        }
                      });
                    },
                  )),
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 22,
          ),
          Center(
            child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  ),
                  shape: BoxShape.circle,
                  color: PrimaryColor,
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 95,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.userData.profilePictureUrl),
                    ),
                    Positioned(
                        bottom: 1,
                        right: 20,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: widget.userData.isActive
                                  ? Colors.green
                                  : Colors.red,
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
                      FirestoreHelper.checkAvaliableMessageRoom(
                              widget.senderData.email,
                              widget.userData.email,
                              false)
                          .then((value) {
                        value.id == ""
                            ? FirestoreHelper.addNewMessageRoom(
                                    false, widget.senderData, widget.userData)
                                .then((value) {
                                if (value != "") {
                                  FirestoreHelper.getSpecificChatRoomInfo(value)
                                      .then((value) {
                                    if (value.id != "") {
                                      print(value.MessageRoomPeople);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  messageRoom: value)));
                                    }
                                  });
                                }
                              })
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(messageRoom: value)));
                      });
                    },
                    child: Text("Send Message")),
                TextButton(
                    onPressed: () {
                      FirestoreHelper.checkAvaliableMessageRoom(
                              widget.senderData.email,
                              widget.userData.email,
                              true)
                          .then((value) {
                        value.id == ""
                            ? FirestoreHelper.addNewMessageRoom(
                                    true, widget.senderData, widget.userData)
                                .then((value) {
                                if (value != "") {
                                  FirestoreHelper.getSpecificChatRoomInfo(value)
                                      .then((value) {
                                    if (value.id != "") {
                                      print(value.MessageRoomPeople);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  messageRoom: value)));
                                    }
                                  });
                                }
                              })
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(messageRoom: value)));
                      });
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(widget.userData.userBio),
            ),
          )
        ],
      ),
    );
  }

  Widget userSpecificInformationLayer() {
    return Center(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
