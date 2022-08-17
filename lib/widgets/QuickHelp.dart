import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:anonmy/widgets/snackbar_pro/snack_bar_pro.dart';
import 'package:anonmy/widgets/snackbar_pro/top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/svg.dart';

class QuickHelp {
  static void showAppNotificationAdvanced(
      {required String title,
      required BuildContext context,
      Widget? avatar,
      String? message,
      bool? isError = true,
      VoidCallback? onTap,
      String? avatarUrl}) {
    showTopSnackBar(
      context,
      SnackBarPro.custom(
        title: title,
        message: message,
        textStyleTitle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isError != null ? Colors.white : Colors.black,
        ),
        textStyleMessage: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 15,
          color: isError != null ? Colors.white : Colors.black,
        ),
        isError: isError,
      ),
      onTap: onTap,
      overlayState: null,
    );
  }
}
