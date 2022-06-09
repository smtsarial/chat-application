import 'package:anonmy/models/story.dart';
import 'package:anonmy/screens/main/story/story_view.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryViewer extends StatefulWidget {
  const StoryViewer(
      {Key? key,
      required this.imageList,
      required this.ownerUsername,
      //required this.storyDate,
      required this.ownerProfilepicture})
      : super(key: key);
  final List<Story> imageList;
  final String ownerUsername;
  //final DateTime storyDate;
  final String ownerProfilepicture;
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
    return StoryView(
      controller: controller,
      repeat: true,
      storyItems: storyItems,
      ownerProfilepicture: widget.ownerProfilepicture,
      ownerUsername: widget.ownerUsername,
      //storyDate: widget.storyDate,
      onComplete: () {
        Navigator.pop(context);
      },
      storyList: widget.imageList,
    );
  }
}
