import 'package:firebasedeneme/connections/firestore.dart';
import 'package:firebasedeneme/models/story.dart';
import 'package:faker/faker.dart';
import 'package:firebasedeneme/theme.dart';
import 'package:flutter/material.dart';

import '../../helper.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late List<Story> stories = [];
  @override
  void initState() {
    FirestoreHelper.FakeStory().then((value) {
      setState(() {
        stories = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 9 / 16,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: stories.length,
          itemBuilder: (BuildContext ctx, index) {
            return Container(
              alignment: Alignment.center,
              child: Text(stories[index].ownerUsername),
              decoration: BoxDecoration(color: PrimaryColor),
            );
          }),
    );
  }
}
