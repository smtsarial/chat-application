import 'dart:math';

import 'package:flutter/material.dart';

/// Popup widget that you can use by default to show some information
class SnackBarPro extends StatefulWidget {
  final String title;
  final String? message;
  final Widget? icon;
  final bool? isError;
  final Color backgroundColor;
  final TextStyle textStyleTitle;
  final TextStyle textStyleMessage;
  final int iconRotationAngle;
  final List<BoxShadow> boxShadow;
  final BorderRadius borderRadius;
  final double iconPositionTop;
  final double iconPositionLeft;
  final EdgeInsetsGeometry messagePadding;
  final double textScaleFactor;

  const SnackBarPro.success({
    Key? key,
    required this.title,
    this.message,
    this.isError,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_very_satisfied,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.textStyleMessage = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xff00E676),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  const SnackBarPro.info({
    Key? key,
    required this.title,
    this.message,
    this.isError,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.sentiment_neutral,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.textStyleMessage = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xff2196F3),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  const SnackBarPro.error({
    Key? key,
    required this.title,
    this.message,
    this.isError,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon = const Icon(
      Icons.error_outline,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.textStyleMessage = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  const SnackBarPro.custom({
    Key? key,
    required this.title,
    this.message,
    this.isError,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 24),
    this.icon,
    this.textStyleTitle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.textStyleMessage = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.iconPositionTop = -10,
    this.iconPositionLeft = -8,
    this.backgroundColor = const Color(0xffff5252),
    this.boxShadow = kDefaultBoxShadow,
    this.borderRadius = kDefaultBorderRadius,
    this.textScaleFactor = 1.0,
  });

  @override
  _SnackBarProState createState() => _SnackBarProState();
}

class _SnackBarProState extends State<SnackBarPro> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.message != null) {
      return Container(
        clipBehavior: Clip.hardEdge,
        height: 80,
        decoration: BoxDecoration(
          color: widget.isError == null
              ? Colors.white
              : widget.isError == true
                  ? Color(0xffff5252)
                  : Color(0xff00E676),
          borderRadius: widget.borderRadius,
          boxShadow: widget.boxShadow,
        ),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              height: 95,
              child: widget.icon != null
                  ? widget.icon
                  : widget.isError == null
                      ? Container()
                      : widget.isError == true
                          ? Icon(
                              Icons.error_outline,
                              color: const Color(0x15000000),
                              size: 80,
                            )
                          : Icon(
                              Icons.sentiment_very_satisfied,
                              color: const Color(0x15000000),
                              size: 80,
                            ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.bodyText2?.merge(
                        widget.textStyleTitle,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textScaleFactor: widget.textScaleFactor,
                    ),
                    Visibility(
                      visible: widget.message != null,
                      child: Text(
                        widget.message != null ? widget.message! : "",
                        style: theme.textTheme.bodyText2?.merge(
                          widget.textStyleMessage,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textScaleFactor: widget.textScaleFactor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      height: 80,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        boxShadow: widget.boxShadow,
      ),
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: widget.iconPositionTop,
            left: widget.iconPositionLeft,
            child: Container(
              height: 95,
              child: Transform.rotate(
                angle: widget.iconRotationAngle * pi / 180,
                child: widget.icon,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: widget.messagePadding,
              child: Text(
                widget.title,
                style: theme.textTheme.bodyText2?.merge(
                  widget.textStyleTitle,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textScaleFactor: widget.textScaleFactor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const kDefaultBoxShadow = const [
  BoxShadow(
    color: Colors.black26,
    offset: Offset(0.0, 8.0),
    spreadRadius: 1,
    blurRadius: 30,
  ),
];

const kDefaultBorderRadius = const BorderRadius.all(Radius.circular(12));
