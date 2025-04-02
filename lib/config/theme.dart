import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs de la marque
  static const Color primaryColor = Color(0xFF007AFF); // Couleur iOS bleu
  static const Color secondaryColor = Color(0xFF34C759); // Vert iOS
  static const Color backgroundColor = Color(0xFFF2F2F7); // Fond iOS

  // Thème clair (style iOS)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      // Utilisation d'une police compatible comme Inter ou SF Pro Text
      textTheme: GoogleFonts.interTextTheme(),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.light,
      ),
      cardTheme: CardTheme(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Thème sombre (style iOS)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: const Color(0xFF1C1C1E), // Fond sombre iOS
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      // Utilisation d'une police compatible comme Inter ou SF Pro Text
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.dark,
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF2C2C2E),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}