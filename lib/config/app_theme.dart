import 'package:flutter/cupertino.dart';

class AppTheme {
  // Couleurs principales
  static const Color primaryColor = CupertinoColors.systemBlue;
  static const Color backgroundColor = CupertinoColors.systemBackground;
  static const Color textColor = CupertinoColors.label;

  static final CupertinoThemeData cupertinoTheme = const CupertinoThemeData(
    primaryColor: primaryColor,
    barBackgroundColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: textColor,
      navTitleTextStyle: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    ),
  );
}