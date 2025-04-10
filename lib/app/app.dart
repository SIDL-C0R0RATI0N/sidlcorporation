import 'package:flutter/cupertino.dart';
import 'package:sidlcorporation/config/app_theme.dart';
import 'package:sidlcorporation/ui/screens/splash_screen.dart';

class SidlApp extends StatelessWidget {
  const SidlApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'SIDL CORPORATION',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.cupertinoTheme,
      home: const SplashScreen(),
    );
  }
}