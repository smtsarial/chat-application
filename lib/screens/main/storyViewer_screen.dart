import 'package:anonmy/models/story.dart';
import 'package:anonmy/screens/main/story/story_view.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';

class StoryViewer extends StatefulWidget {
  const StoryViewer({Key? key, required this.imageList}) : super(key: key);
  final List<Story> imageList;
  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

@override
class _StoryViewerState extends State<StoryViewer> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];
  @override
  void initState() {
    super.initState();
    widget.imageList.forEach((element) {
      storyItems.add(StoryItem.inlineImage(
          ownerProfilepicture: element.ownerProfilePicture,
          storyDate: element.createdTime,
          ownerUsername: element.ownerUsername,
          url: element.imageUrl,
          controller: controller,
          duration: Duration(seconds: 14)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StoryView(
          controller: controller,
          repeat: true,
          storyItems: storyItems,
          onComplete: () {
            Navigator.pop(context);
          }),
    );
  }
}
