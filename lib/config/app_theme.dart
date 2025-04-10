import 'package:flutter/cupertino.dart';

class AppTheme {
  // Couleurs du thème clair
  static const Color lightPrimaryColor = CupertinoColors.systemBlue;
  static const Color lightBackgroundColor = CupertinoColors.systemBackground;
  static const Color lightTextColor = CupertinoColors.label;
  static const Color lightCardColor = CupertinoColors.secondarySystemBackground;

  // Couleurs du thème sombre
  static const Color darkPrimaryColor = CupertinoColors.systemBlue;
  static const Color darkBackgroundColor = CupertinoColors.black;
  static const Color darkTextColor = CupertinoColors.white;
  static const Color darkCardColor = Color(0xFF1C1C1E);

  // Thème clair
  static final CupertinoThemeData lightCupertinoTheme = const CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    barBackgroundColor: lightBackgroundColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: lightTextColor,
      navTitleTextStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: lightTextColor,
      ),
    ),
  );

  // Thème sombre
  static final CupertinoThemeData darkCupertinoTheme = const CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    barBackgroundColor: darkBackgroundColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: darkTextColor,
      navTitleTextStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: darkTextColor,
      ),
    ),
  );
}