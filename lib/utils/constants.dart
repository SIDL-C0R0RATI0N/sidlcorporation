import 'package:flutter/material.dart';

class Constants {
  // Clés pour SharedPreferences
  static const String prefDarkMode = 'darkMode';
  static const String prefNotifications = 'notifications';
  static const String prefUserLoggedIn = 'userLoggedIn';
  static const String prefUserToken = 'userToken';
  static const String prefUserId = 'userId';
  static const String prefUserName = 'userName';
  static const String prefUserEmail = 'userEmail';
  static const String prefFirstLaunch = 'firstLaunch';
  static const String prefLastNewsRefresh = 'lastNewsRefresh';

  // Messages d'erreur
  static const String errorGeneric = 'Une erreur est survenue. Veuillez réessayer.';
  static const String errorNetwork = 'Erreur de connexion. Veuillez vérifier votre connexion Internet.';
  static const String errorServer = 'Erreur du serveur. Veuillez réessayer ultérieurement.';
  static const String errorAuth = 'Erreur d\'authentification. Veuillez vous reconnecter.';
  static const String errorNotFound = 'Contenu non trouvé.';
  static const String errorTimeout = 'La requête a pris trop de temps. Veuillez réessayer.';

  // Formats de date
  static const String dateFormatFull = 'dd/MM/yyyy HH:mm';
  static const String dateFormatShort = 'dd/MM/yyyy';
  static const String dateFormatNews = 'd MMMM yyyy';
  static const String dateFormatTime = 'HH:mm';

  // Routes de navigation
  static const String routeHome = '/';
  static const String routeSplash = '/splash';
  static const String routeNewsroom = '/newsroom';
  static const String routeSettings = '/settings';
  static const String routeWebView = '/webview';

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(milliseconds: 2500);

  // Dimensions
  static const double borderRadius = 16.0;
  static const double cardElevation = 0.0;
  static const double defaultPadding = 16.0;
  static const double appBarHeight = 56.0;

  // Limits
  static const int maxNewsItems = 50;
  static const int refreshTimeoutMinutes = 5;
}