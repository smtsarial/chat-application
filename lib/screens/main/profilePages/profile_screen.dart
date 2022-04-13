import 'package:anonmy/models/story.dart';
import 'package:anonmy/screens/main/chat/messages/chat_screen.dart';
import 'package:anonmy/screens/main/storyViewer_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    print(widget.userData.firstName);
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
          const BackButton(),
          const SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData.firstName + " " + widget.userData.lastName,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          )
        ],
      ),
      actions: [
        const SizedBox(width: kDefaultPadding / 2),
        Center(
            child: follower
                ? GestureDetector(
                    child: const Text("Unfollow"),
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
                          setState(() {
                            follower = false;
                          });
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
                    child: const Text("Follow"),
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
                          setState(() {
                            follower = true;
                          });
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
        const SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }

  Widget body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 22,
          ),
          Center(
            child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
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
          const SizedBox(
            height: 22,
          ),
          const Divider(),
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
                    child: const Text("Send Message")),
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
                    child: const Text("Send Message Anonymously"))
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          _Stories(
            userData: widget.userData,
          ),
          userSpecificInformationLayer(),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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

class _Stories extends StatefulWidget {
  const _Stories({Key? key, required this.userData}) : super(key: key);
  final User userData;
  @override
  State<_Stories> createState() => _StoriesState();
}

class _StoriesState extends State<_Stories> {
  List<Story> stories = [];
  @override
  void initState() {
    FirestoreHelper.getStoriesForUser(widget.userData).then((value) {
      setState(() {
        stories = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 0,
        child: SizedBox(
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 8, bottom: 16),
                child: Text(
                  'Stories',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: AppColors.textFaded,
                  ),
                ),
              ),
              stories.length != 0
                  ? (Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: stories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 60,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StoryViewer(
                                                  imageList: stories,
                                                )));
                                  },
                                  child: _StoryCard(storyData: stories[index])),
                            ),
                          );
                        },
                      ),
                    ))
                  : (const Center(
                      child: Text(
                        "There is no story",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppColors.textFaded,
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

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    Key? key,
    required this.storyData,
  }) : super(key: key);

  final Story storyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Avatar.medium(url: storyData.imageUrl),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              timeago.format(storyData.createdTime),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
