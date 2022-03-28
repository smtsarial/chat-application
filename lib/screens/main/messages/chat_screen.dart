import 'package:anonmy/screens/main/messages/components/body.dart';
import 'package:anonmy/theme.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          CircleAvatar(
            radius: 20,
            backgroundImage: Image(
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/denemeprojem-65ebc.appspot.com/o/profileImages%2Fimage_picker8854925666362766770.jpg'?alt=media&token=1440a674-0a91-4bb9-91e7-6c2137132eba"))
                .image,
          ),
          SizedBox(width: kDefaultPadding * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kristin Watson",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        SizedBox(width: kDefaultPadding / 2),
      ],
    );
  }
}
