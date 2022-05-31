import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class showImagePage extends StatefulWidget {
  const showImagePage({Key? key, required this.image}) : super(key: key);
  final List image;
  @override
  State<showImagePage> createState() => _showImagePageState();
}

class _showImagePageState extends State<showImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(children: [
        Container(
          child: PhotoView(
            imageProvider: NetworkImage(widget.image[0]),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: FloatingActionButton(
            backgroundColor: Colors.grey,
            child: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ])),
    );
  }
}
