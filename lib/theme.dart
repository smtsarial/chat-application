import 'package:anonmy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String REGISTERED_APP_ID = "6204";
const String REGISTERED_AUTH_KEY = "3L6MknPCfmutGO6";
const String REGISTERED_AUTH_SECRET = "dhjvGJO7h9GhPu9";

final String PARAM_SESSION_ID = 'session_id';
final String PARAM_CALL_TYPE = 'call_type';
final String PARAM_CALLER_ID = 'caller_id';
final String PARAM_CALLER_NAME = 'caller_name';
final String PARAM_CALL_OPPONENTS = 'call_opponents';
final String PARAM_IOS_VOIP = 'ios_voip';
final String PARAM_SIGNAL_TYPE = 'signal_type';

final String SIGNAL_TYPE_START_CALL = "startCall";
final String SIGNAL_TYPE_END_CALL = "endCall";
final String SIGNAL_TYPE_REJECT_CALL = "rejectCall";

User emptyUser = User(
    "",
    "",
    0,
    0,
    "",
    [],
    [],
    "",
    true,
    DateTime.now(),
    "",
    "",
    [],
    "",
    [],
    "",
    "",
    "",
    "",
    [],
    [],
    [],
    [],
    [],
    true,
    [],
    "",
    0,
    [],
    true);
const String MOVIE_API = "394fa7228e1dfa390c0d581873d61b1b";
const String YOUTUBE_API_KEY = "AIzaSyDnfTj8E3A0vTUral0taQhiYP4nvfQacpA";

class CallTypes {
  static const VIDEO_CALL = 1;
  static const AUDIO_CALL = 2;
}

const PrimaryColor = Color.fromRGBO(73, 3, 201, 1);
const SecondaryColor = Color.fromRGBO(59, 24, 95, 1);
const ThirdColor = Color.fromRGBO(161, 37, 104, 1);
const PureColor = Colors.white54;
const TextColor = Colors.white54;
const ContentColorDarkTheme = Color(0xFFF5FCF9);
const WarninngColor = Color(0xFFF3BB1C);
const ErrorColor = Color(0xFFF03738);
const PurchaseColor = Color.fromARGB(255, 53, 167, 0);

const kPrimaryColor = Color.fromRGBO(73, 3, 201, 1);
const kSecondaryColor = Color.fromRGBO(59, 24, 95, 1);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

abstract class AppColors {
  static const secondary = Color(0xFF3B76F6);
  static const accent = Color(0xFFD6755B);
  static const textDark = Color(0xFF53585A);
  static const textLigth = Color(0xFFF5F5F5);
  static const textFaded = Color(0xFF9899A5);
  static const iconLight = Color(0xFFB1B4C0);
  static const iconDark = Color(0xFFB1B3C1);
  static const textHighlight = secondary;
  static const cardLight = Color(0xFFF9FAFE);
  static const cardDark = Color(0xFF303334);
}

abstract class _LightColors {
  static const background = Color.fromARGB(255, 173, 173, 173);
  static const card = AppColors.cardLight;
}

abstract class _DarkColors {
  static const background = Color(0xFF1B1E1F);
  static const card = AppColors.cardDark;
}

/// Reference to the application theme.
abstract class AppTheme {
  static const accentColor = AppColors.accent;
  static final visualDensity = VisualDensity.adaptivePlatformDensity;

  /// Light theme and its settings.
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        accentColor: accentColor,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.mulishTextTheme().apply(bodyColor: AppColors.textDark),
        backgroundColor: _LightColors.background,
        scaffoldBackgroundColor: _LightColors.background,
        cardColor: _LightColors.card,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: AppColors.textDark),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconDark),
      );

  /// Dark theme and its settings.
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
        visualDensity: visualDensity,
        textTheme:
            GoogleFonts.interTextTheme().apply(bodyColor: AppColors.textLigth),
        backgroundColor: _DarkColors.background,
        scaffoldBackgroundColor: _DarkColors.background,
        cardColor: _DarkColors.card,
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(color: AppColors.textLigth),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconLight),
      );
}
