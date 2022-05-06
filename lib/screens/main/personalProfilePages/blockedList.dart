import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:anonmy/widgets/avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BlockedUsers extends StatefulWidget {
  const BlockedUsers({Key? key}) : super(key: key);

  @override
  State<BlockedUsers> createState() => _BlockedUsersState();
}

class _BlockedUsersState extends State<BlockedUsers> {
  bool isLoaded = false;
  List<User> list = [];
  @override
  void initState() {
    if (mounted) {
      getAllBlockedUsers().then((value) {
        setState(() {
          isLoaded = true;
        });
      });
    }
    super.initState();
  }

  Future getAllBlockedUsers() async {
    await FirestoreHelper.getUserData().then((value) {
      List<User> list1 = [];
      value.blockedUsers.forEach((element) async {
        var data = await FirestoreHelper.db
            .collection('users')
            .where("email", isEqualTo: element)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            list1.add(User.fromMap(element));
          });
        });
        setState(() {
          list = list1;
          isLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Blocked Users"),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            isLoaded == false
                ? Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.deepPurple,
                      highlightColor: Colors.white,
                      child: Image.asset(
                        "assets/images/seffaf_renkli.png",
                        height: 150,
                      ),
                    ),
                  )
                : Expanded(
                    child: list.length != 0
                        ? ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, position) {
                              User item = list[position];
                              return Column(
                                children: [
                                  ListTile(
                                      onTap: () => {},
                                      leading: Container(
                                          height: double.infinity,
                                          child: Avatar.medium(
                                              url: item.profilePictureUrl)),
                                      title: Text(
                                        item.firstName.toString() +
                                            " " +
                                            item.lastName.toString(),
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
                                                      "Remove",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    try {
                                                      var data =
                                                          await FirestoreHelper
                                                                  .getUserData()
                                                              .then(
                                                                  (value) async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(value.id)
                                                            .update({
                                                          "blockedUsers":
                                                              FieldValue
                                                                  .arrayRemove([
                                                            item.email
                                                          ])
                                                        });
                                                      }).then((value) {
                                                        list.remove(item);
                                                        getAllBlockedUsers()
                                                            .then((value) {
                                                          setState(() {
                                                            isLoaded = true;
                                                          });
                                                        });
                                                      });
                                                    } catch (e) {
                                                      print(e);
                                                    }
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
                            child: Text("There is no blocked user",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ))
          ],
        )),
      ),
    );
  }
}
