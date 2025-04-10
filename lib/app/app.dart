import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sidlcorporation/config/app_theme.dart';
import 'package:sidlcorporation/config/theme_provider.dart';
import 'package:sidlcorporation/ui/screens/splash_screen.dart';

class SidlApp extends StatelessWidget {
  const SidlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CupertinoApp(
      title: 'SIDL CORPORATION',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode
          ? AppTheme.darkCupertinoTheme
          : AppTheme.lightCupertinoTheme,
      home: const SplashScreen(),
    );
  }
}