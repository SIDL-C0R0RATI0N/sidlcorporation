import 'package:flutter/material.dart';
import '../widgets/web_view_container.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  // Singleton pattern
  static final NavigationHelper _instance = NavigationHelper._internal();
  factory NavigationHelper() => _instance;
  NavigationHelper._internal();

  /// Ouvre une URL dans le navigateur WebView interne
  void openInAppWebView(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(
          url: url,
          title: title,
        ),
      ),
    );
  }

  /// Ouvre une URL dans le navigateur par défaut du système
  Future<void> openInExternalBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Impossible d\'ouvrir l\'URL: $url';
    }
  }

  /// Ouvre une URL dans le navigateur interne ou externe selon le paramètre
  Future<void> openUrl(BuildContext context, String url, String title, {bool useExternalBrowser = false}) async {
    if (useExternalBrowser) {
      await openInExternalBrowser(url);
    } else {
      openInAppWebView(context, url, title);
    }
  }

  /// Ouvre un email
  Future<void> openEmail(String email, {String subject = '', String body = ''}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Impossible d\'ouvrir le client email pour: $email';
    }
  }

  /// Ouvre un numéro de téléphone
  Future<void> openPhoneCall(String phoneNumber) async {
    final Uri telUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      throw 'Impossible d\'ouvrir le téléphone pour: $phoneNumber';
    }
  }

  /// Navigation avec animation (slide)
  void navigateWithSlideAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}