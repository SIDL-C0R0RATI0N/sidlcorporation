import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sidlcorporation/utils/theme_provider.dart' as utils;
import 'screens/splash_screen.dart';
import 'config/theme.dart';
import 'package:provider/provider.dart';
import 'utils/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de la barre de statut système pour afficher les icônes
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SIDL CORPORATION',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode == utils.ThemeMode.system
          ? flutter.ThemeMode.system
          : themeProvider.themeMode == utils.ThemeMode.light
          ? flutter.ThemeMode.light
          : flutter.ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}