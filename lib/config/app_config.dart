class AppConfig {
  // Configuration de l'API
  static const String apiBaseUrl = 'https://api.sidl-corporation.fr/v5/app/ios';

  // Configuration de l'application
  static const String appName = 'SIDL CORPORATION';
  static const String appDescription = 'Application officielle de SIDL CORPORATION';

  // Information de version (remplace PackageInfo)
  static const String appVersion = '0.1.0';
  static const String buildNumber = '4';

  // Configuration des liens
  static const String websiteUrl = 'https://sidl-corporation.fr';
  static const String rssUrl = 'https://www.sidl-corporation.fr/feed';
  static const String privacyPolicyUrl = 'https://sidl-corporation.fr/privacy';
  static const String termsOfServiceUrl = 'https://sidl-corporation.fr/terms';
  static const String supportUrl = 'https://sidl-corporation.fr/contact';

  // Configuration des fonctionnalités
  static const bool enableNotifications = true;
  static const bool enableDarkMode = true;
  static const int newsRefreshInterval = 300; // En secondes

  // Configuration des temps d'attente
  static const int splashScreenDuration = 2500; // En millisecondes
  static const int apiTimeout = 10000; // En millisecondes

  // Configuration de l'interface utilisateur
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;

  // Constantes pour les animations
  static const int defaultAnimationDuration = 300; // En millisecondes
}