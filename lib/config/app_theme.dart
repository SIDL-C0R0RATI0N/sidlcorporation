import 'package:flutter/cupertino.dart';

class AppTheme {
  // Nouvelles couleurs pour le design
  static const Color primaryLight = Color(0xFF007AFF); // Bleu iOS
  static const Color primaryDark = Color(0xFF0A84FF);  // Bleu iOS plus clair

  // Couleurs secondaires
  static const Color accentLight = Color(0xFFFF9500); // Orange iOS
  static const Color accentDark = Color(0xFFFF9F0A);  // Orange iOS plus clair

  // Couleurs de fond
  static const Color backgroundLight = CupertinoColors.systemBackground;
  static const Color backgroundDark = Color(0xFF121212); // Fond vraiment sombre

  // Couleurs de carte
  static const Color cardLight = Color(0xFFF5F5F7);  // Gris très léger
  static const Color cardDark = Color(0xFF1E1E1E);   // Gris très foncé

  // Thème clair
  static final CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    barBackgroundColor: backgroundLight.withOpacity(0.85),
    textTheme: const CupertinoTextThemeData(
      primaryColor: Color(0xFF000000),
      navTitleTextStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      textStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 16.0,
      ),
    ),
  );

  // Thème sombre
  static final CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    barBackgroundColor: backgroundDark.withOpacity(0.85),
    textTheme: const CupertinoTextThemeData(
      primaryColor: Color(0xFFFFFFFF),
      navTitleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 34.0,
        fontWeight: FontWeight.bold,
      ),
      textStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 16.0,
      ),
    ),
  );
}