import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:anonmy/connections/firestore.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/control_provider.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/sevices/save_as_image.dart';
import 'package:anonmy/screens/main/story/src/presentation/utils/constants/item_type.dart';
import 'package:anonmy/screens/main/story/src/presentation/utils/constants/text_animation_type.dart';
import 'package:anonmy/screens/main/story/src/presentation/widgets/animated_onTap_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomTools extends StatefulWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Function renderWidget;

  /// editor background color
  final Color? editorBackgroundColor;
  const BottomTools(
      {Key? key,
      required this.contentKey,
      required this.onDone,
      required this.renderWidget,
      this.onDoneButtonStyle,
      this.editorBackgroundColor})
      : super(key: key);

  @override
  State<BottomTools> createState() => _BottomToolsState();
}

class _BottomToolsState extends State<BottomTools> {
  Future<File?> saveImagePermanently(String? imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath!);
    final image = File('${directory.path}/$name');
    print("kaydedildi");
    return File(imagePath).copy(image.path);
  }

  bool isShared = false;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool _createVideo = false;

    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              Container(
                width: _size.width / 3,
                height: _size.width / 3,
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  child: _preViewContainer(
                    /// if [model.imagePath] is null/empty return preview image
                    child: controlNotifier.mediaPath.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GestureDetector(
                              onTap: () async {
                                // scroll to gridView page
                                if (controlNotifier.mediaPath.isEmpty) {
                                  scrollNotifier.pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                }
                                //final XFile? image = await _picker
                                //    .pickImage(source: ImageSource.gallery)
                                //    .then((value) async {
                                //  final Directory? directory =
                                //      await getExternalStorageDirectory();
                                //  print(directory.toString());
                                //  print(basename(value!.path).toString());
                                //  controlNotifier.mediaPath =
                                //      directory.toString() +
                                //          "/Pictures" +
                                //          basename(value.path).toString();
                                //});
                              },
                              child: const CoverThumbnail(
                                thumbnailQuality: 150,
                              ),
                            ))

                        /// return clear [imagePath] provider
                        : GestureDetector(
                            onTap: () {
                              /// clear image url variable
                              controlNotifier.mediaPath = '';
                              itemNotifier.draggableWidget.removeAt(0);
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              color: Colors.transparent,
                              child: Transform.scale(
                                scale: 0.7,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),

              //CAMERA IMAGE TAKE
              //Container(
              //  width: _size.width / 3,
              //  height: _size.width / 3,
              //  padding: const EdgeInsets.only(left: 15),
              //  alignment: Alignment.centerLeft,
              //  child: SizedBox(
              //    child: _preViewContainer(
              //      /// if [model.imagePath] is null/empty return preview image
              //      child: controlNotifier.mediaPath.isEmpty
              //          ? ClipRRect(
              //              borderRadius: BorderRadius.circular(8),
              //              child: GestureDetector(
              //                  onTap: () async {
              //                    final XFile? image = await _picker
              //                        .pickImage(source: ImageSource.camera)
              //                        .then((value) async {
              //                      print(value!.path.toString());
              //                      if (value != null && value.path != null) {
              //                        print('saving in progress...');
              //                        await GallerySaver.saveImage(value.path)
              //                            .then((path) {
              //                          print("+++++++++++++++++++++++++");
              //                          print('image saved!');
              //                        });
              //                      }
              //                      //await saveImagePermanently(value.path);
              //                      //controlNotifier.mediaPath =
              //                      //    File(value.path).toString();
              //                    });
//
              //                    /// scroll to gridView page
              //                    //if (controlNotifier.mediaPath.isEmpty) {
              //                    //  scrollNotifier.pageController.animateToPage(
              //                    //      1,
              //                    //      duration:
              //                    //          const Duration(milliseconds: 300),
              //                    //      curve: Curves.ease);
              //                    //}
              //                  },
              //                  child: Icon(Icons.camera_alt)))
//
              //          /// return clear [imagePath] provider
              //          : GestureDetector(
              //              onTap: () {
              //                /// clear image url variable
              //                controlNotifier.mediaPath = '';
              //                itemNotifier.draggableWidget.removeAt(0);
              //              },
              //              child: Container(
              //                height: 45,
              //                width: 45,
              //                color: Colors.transparent,
              //                child: Transform.scale(
              //                  scale: 0.7,
              //                  child: const Icon(
              //                    Icons.delete,
              //                    color: Colors.white,
              //                  ),
              //                ),
              //              ),
              //            ),
              //    ),
              //  ),
              //  ),

              /// center logo
              controlNotifier.middleBottomWidget != null
                  ? Center(
                      child: Container(
                          width: _size.width / 3,
                          height: 80,
                          alignment: Alignment.bottomCenter,
                          child: controlNotifier.middleBottomWidget),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //HERE IS THE LOGO SIDE ON THE BOTTOM
                        ],
                      ),
                    ),

              /// save final image to gallery
              Container(
                width: _size.width / 3,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                child: Transform.scale(
                  scale: 0.9,
                  child: StatefulBuilder(
                    builder: (_, setState) {
                      return AnimatedOnTapButton(
                          onTap: () async {
                            String pngUri;
                            if (paintingNotifier.lines.isNotEmpty ||
                                itemNotifier.draggableWidget.isNotEmpty) {
                              setState(() {
                                isShared = true;
                              });
                              for (var element
                                  in itemNotifier.draggableWidget) {
                                if (element.type == ItemType.gif ||
                                    element.animationType !=
                                        TextAnimationType.none) {
                                  setState(() {
                                    _createVideo = true;
                                  });
                                }
                              }
                              if (_createVideo) {
                                debugPrint('creating video');
                                await widget.renderWidget();
                                await takePicture(
                                        contentKey: widget.contentKey,
                                        context: context,
                                        saveToGallery: false)
                                    .then((bytes) {
                                  if (bytes != null) {
                                    print(widget.contentKey);
                                    FirestoreHelper.uploadStoryToStorage(bytes)
                                        .then((imageURL) async {
                                      print(imageURL);
                                      FirestoreHelper.saveNewStories(imageURL)
                                          .then((value) {
                                        print(value);
                                        Navigator.pop(context);
                                      });
                                    });
                                  } else {}
                                });
                              } else {
                                debugPrint('creating image');
                                await takePicture(
                                        contentKey: widget.contentKey,
                                        context: context,
                                        saveToGallery: false)
                                    .then((bytes) {
                                  if (bytes != null) {
                                    print(widget.contentKey);
                                    FirestoreHelper.uploadStoryToStorage(bytes)
                                        .then((imageURL) async {
                                      print(imageURL);
                                      FirestoreHelper.saveNewStories(imageURL)
                                          .then((value) {
                                        print(value);
                                        Navigator.pop(context);
                                      });
                                    });
                                  } else {}
                                });
                              }
                            }
                            setState(() {
                              _createVideo = false;
                            });
                          },
                          child: isShared != true
                              ? widget.onDoneButtonStyle ??
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 5, top: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.white, width: 1.5)),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.share,
                                            style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.5,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ]),
                                  )
                              : Container(
                                  child: CircularProgressIndicator(
                                      color: Colors.grey)));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }
}
