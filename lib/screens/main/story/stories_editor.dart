// ignore_for_file: must_be_immutable
library stories_editor;

import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/control_provider.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/gradient_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/rendering_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:anonmy/screens/main/story/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:anonmy/screens/main/story/src/presentation/main_view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StoriesEditor extends StatefulWidget {
  /// editor custom font families
  final List<String>? fontFamilyList;

  /// editor custom font families package
  final bool? isCustomFontList;

  /// giphy api key
  final String giphyKey;

  /// editor custom color gradients
  final List<List<Color>>? gradientColors;

  /// editor custom logo
  final Widget? middleBottomWidget;

  /// on done
  final Function(String)? onDone;

  /// on done button Text
  final Widget? onDoneButtonStyle;

  /// on back pressed
  final Future<bool>? onBackPress;

  /// editor custom color palette list
  final List<Color>? colorList;

  /// editor background color
  final Color? editorBackgroundColor;

  /// gallery thumbnail quality
  final int? galleryThumbnailQuality;

  const StoriesEditor(
      {Key? key,
      required this.giphyKey,
      required this.onDone,
      this.middleBottomWidget,
      this.colorList,
      this.gradientColors,
      this.fontFamilyList,
      this.isCustomFontList,
      this.onBackPress,
      this.onDoneButtonStyle,
      this.editorBackgroundColor,
      this.galleryThumbnailQuality})
      : super(key: key);

  @override
  _StoriesEditorState createState() => _StoriesEditorState();
}

class _StoriesEditorState extends State<StoriesEditor> {
  @override
  void initState() {
    Paint.enableDithering = true;
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.initState();
  }

  @override
  void dispose() {
    //Provider.of<ControlNotifier>(context, listen: false).dispose();
    //Provider.of<ScrollNotifier>(context, listen: false).dispose();
    //Provider.of<DraggableWidgetNotifier>(context, listen: false).dispose();
    //Provider.of<GradientNotifier>(context, listen: false).dispose();
    //Provider.of<PaintingNotifier>(context, listen: false).dispose();
    //Provider.of<TextEditingNotifier>(context, listen: false).dispose();
    //Provider.of<RenderingNotifier>(context, listen: false).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControlNotifier()),
        ChangeNotifierProvider(create: (_) => ScrollNotifier()),
        ChangeNotifierProvider(create: (_) => DraggableWidgetNotifier()),
        ChangeNotifierProvider(create: (_) => GradientNotifier()),
        ChangeNotifierProvider(create: (_) => PaintingNotifier()),
        ChangeNotifierProvider(create: (_) => TextEditingNotifier()),
        ChangeNotifierProvider(create: (_) => RenderingNotifier()),
      ],
      child: MainView(
        giphyKey: widget.giphyKey,
        onDone: widget.onDone,
        fontFamilyList: widget.fontFamilyList,
        isCustomFontList: widget.isCustomFontList,
        middleBottomWidget: widget.middleBottomWidget,
        gradientColors: widget.gradientColors,
        colorList: widget.colorList,
        onDoneButtonStyle: widget.onDoneButtonStyle,
        onBackPress: widget.onBackPress,
        editorBackgroundColor: widget.editorBackgroundColor,
        galleryThumbnailQuality: widget.galleryThumbnailQuality,
      ),
    );
  }
}
