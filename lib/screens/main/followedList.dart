import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FollowedList extends StatefulWidget {
  const FollowedList({Key? key}) : super(key: key);

  @override
  State<FollowedList> createState() => _FollowedListState();
}

class _FollowedListState extends State<FollowedList> {
  User user = User("", "", 0, 0, "", [], [], "", true, DateTime.now(), "", "",
      [], "", [], "", "", "", "");
  List list = [];
  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getUserData().then((value) {
        setState(() {
          user = value;
          list = value.followers;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Followed List"),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            user.id == ""
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  )
                : Expanded(
                    child: user.followed.isNotEmpty
                        ? ListView.builder(
                            itemCount: user.followed.length,
                            itemBuilder: (context, position) {
                              String item = user.followed[position];
                              return Column(
                                children: [
                                  ListTile(
                                      onTap: () => {},
                                      leading: Container(
                                        height: double.infinity,
                                        child: Icon(Icons.person),
                                      ),
                                      title: Text(
                                        item.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Wrap(
                                        spacing: 12,
                                        children: [
                                          Container(
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8),
                                                    decoration: BoxDecoration(
                                                      color: null,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24),
                                                      border: Border.all(
                                                        color:
                                                            Colors.grey[300]!,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Unfollow",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    FirestoreHelper
                                                            .removeFollowedUser(
                                                                user.id,
                                                                item.toString())
                                                        .then((value) {
                                                      if (value == true) {
                                                        FirestoreHelper
                                                                .getUserData()
                                                            .then((value) {
                                                          setState(() {
                                                            user = value;
                                                            list =
                                                                value.followers;
                                                          });
                                                          Provider.of<UserProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .updateUserData();
                                                        });
                                                      } else {}
                                                    });
                                                  },
                                                )
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
                            child: Text("There is no followed user !",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ))
          ],
        )),
      ),
    );
  }
}
