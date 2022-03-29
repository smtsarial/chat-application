import 'package:anonmy/screens/main/followedList.dart';
import 'package:anonmy/screens/main/followersList.dart';
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(user.firstName + " " + user.lastName),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 36,
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
                const Divider(),
                const _SignOutButton(),
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
    return _loading
        ? const CircularProgressIndicator()
        : TextButton(
            onPressed: _signOut,
            child: const Text('Sign out'),
          );
  }
}
