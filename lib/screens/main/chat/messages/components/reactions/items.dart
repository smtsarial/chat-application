import 'package:anonmy/models/ChatMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction<String>(
  value: "empty",
  icon: Icon(Icons.add_reaction_outlined),
);

final reactions = [
  Reaction<String>(
    value: 'Happy',
    title: _buildTitle('Happy'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/happy.png'),
    icon: buildReactionsIcon(
      'assets/images/happy.png',
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: _buildTitle('Angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/angry.png'),
    icon: buildReactionsIcon(
      'assets/images/angry.png',
    ),
  ),
  Reaction<String>(
    value: 'Inlove',
    title: _buildTitle('Inlove'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/in-love.png'),
    icon: buildReactionsIcon(
      'assets/images/in-love.png',
    ),
  ),
  Reaction<String>(
    value: 'Sad',
    title: _buildTitle('Sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/sad.png'),
    icon: buildReactionsIcon(
      'assets/images/sad.png',
    ),
  ),
  Reaction<String>(
    value: 'Surprised',
    title: _buildTitle('Surprised'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/surprised.png'),
    icon: buildReactionsIcon(
      'assets/images/surprised.png',
    ),
  ),
  Reaction<String>(
    value: 'Mad',
    title: _buildTitle('Mad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/mad.png'),
    icon: buildReactionsIcon(
      'assets/images/mad.png',
    ),
  ),
  Reaction<String>(
    value: 'empty',
    title: _buildTitle('empty'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/delete.png'),
    icon: buildReactionsIcon(
      'assets/images/delete.png',
    ),
  ),
];

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      "",
      style: TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Image _buildIcon(String path) {
  return Image.asset(
    path,
    height: 30,
    width: 30,
  );
}

Container buildReactionsIcon(String path) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
      ],
    ),
  );
}

showReactionIcon(ChatMessage? message) {
  switch (message!.messageReaction) {
    case "Happy":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/happy.png'),
      ));
    case "Angry":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/angry.png'),
      ));
    case "Inlove":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/in-love.png'),
      ));
    case "Sad":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/sad.png'),
      ));
    case "Surprised":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/surprised.png'),
      ));
    case "Mad":
      return Container(
          child: FittedBox(
        child: buildReactionsIcon('assets/images/mad.png'),
      ));
    case "empty":
      return Container();
    default:
      return Container();
  }
}

initialReaction(ChatMessage? message) {
  switch (message!.messageReaction) {
    case "Happy":
      return reactions[0];
    case "Angry":
      return reactions[1];
    case "Inlove":
      return reactions[2];
    case "Sad":
      return reactions[3];
    case "Surprised":
      return reactions[4];
    case "Mad":
      return reactions[5];
    case "empty":
      return defaultInitialReaction;
    default:
      return defaultInitialReaction;
  }
}
