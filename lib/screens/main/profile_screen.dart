import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/story.dart';
import 'package:anonmy/screens/main/followedList.dart';
import 'package:anonmy/screens/main/followersList.dart';
import 'package:anonmy/screens/main/landing_screen.dart';
import 'package:anonmy/screens/main/myStoriesList_screen.dart';
import 'package:anonmy/screens/main/profileSetting_screen.dart';
import 'package:anonmy/screens/main/settings.dart';
import 'package:anonmy/screens/main/storyViewer_screen.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anonmy/connections/auth.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:anonmy/screens/main/splash_screen.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColor,
          centerTitle: true,
          title: Text(user.firstName + " " + user.lastName),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
                icon: Icon(Icons.settings)),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FollowersList()));
                              },
                              icon: FaIcon(FontAwesomeIcons.users)),
                          Text("Followers"),
                          Text(user.followers.length.toString())
                        ],
                      )),
                      Column(
                        children: [
                          Center(
                            child: Text(
                              "@" + user.username,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
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
                            child: CircleAvatar(
                              radius: 82,
                              backgroundImage: CachedNetworkImageProvider(
                                  user.profilePictureUrl),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          child: Column(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FollowedList()));
                              },
                              icon: FaIcon(FontAwesomeIcons.users)),
                          Text("Followed"),
                          Text(user.followed.length.toString())
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: Text(
                    "Edit My Stories",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyStoriesScreen()));
                  },
                ),
                _Stories(userData: user),
                SizedBox(
                  height: 20,
                ),
                Container(
                    child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rocket_launch,
                          size: 40,
                          color: Color.fromARGB(255, 255, 153, 0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Get More Messages!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Get Shuffle Proote, be on top of the shuffle list.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      width: 300.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: PrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        child: Text(
                          "Update My Account",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ));
  }
}

class _SignOutButton extends StatefulWidget {
  const _SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  __SignOutButtonState createState() => __SignOutButtonState();
}

class __SignOutButtonState extends State<_SignOutButton> {
  bool _loading = false;

  Future<void> _signOut() async {
    Authentication().signOut().then((value) async {
      var sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userUID", "");
      setState(() {
        _loading = true;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SplashScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _signOut,
      child: const Text('Sign out'),
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
