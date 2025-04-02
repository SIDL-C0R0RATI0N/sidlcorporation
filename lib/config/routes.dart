import 'package:flutter/material.dart';
import 'package:sidlcorporation/screens/home_screen.dart';
import 'package:sidlcorporation/screens/settings_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/home': (context) => const HomeScreen(),
    '/settings': (context) => const SettingsScreen(),
  };
}