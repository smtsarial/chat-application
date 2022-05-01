import 'package:anonmy/connections/firestore.dart';
import 'package:anonmy/models/user.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({Key? key}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  User user = emptyUser;

  @override
  void initState() {
    FirestoreHelper.getUserData().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.followerslist),
      ),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            user.id == ""
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Colors.blueGrey,
                      strokeWidth: 2,
                    ),
                  )
                : Expanded(
                    child: user.followers.isNotEmpty
                        ? ListView.builder(
                            itemCount: user.followers.length,
                            itemBuilder: (context, position) {
                              String item = user.followers[position];
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
                                                Text(""),
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
                                    .thereisnofollowers,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ))
          ],
        )),
      ),
    );
  }
}
