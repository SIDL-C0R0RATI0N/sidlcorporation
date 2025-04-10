import 'dart:ui';
import 'package:flutter/cupertino.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final Widget? trailing;
  final Function(int) onTabSelected;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      // Corps principal
      child: Stack(
        children: [
          // Contenu principal
          body,

          // Barre de navigation translucide en haut
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildBlurredNavBar(context, isDarkMode),
          ),

          // Barre de menu translucide en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBlurredTabBar(context, isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredNavBar(BuildContext context, bool isDarkMode) {
    // Obtenir la taille du padding de la barre d'état de manière dynamique
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          // Hauteur augmentée et dynamique basée sur la barre d'état
          height: statusBarHeight + 55, // 55px pour la barre de navigation + hauteur de la barre d'état
          padding: EdgeInsets.only(
            top: statusBarHeight, // Padding dynamique basé sur la hauteur de la barre d'état
            left: 16,
            right: 16,
            bottom: 10, // Padding en bas pour centrer verticalement le contenu
          ),
          decoration: BoxDecoration(
            color: (isDarkMode
                ? CupertinoColors.black
                : CupertinoColors.white)
                .withOpacity(0.8), // Augmenté l'opacité pour plus de lisibilité
            border: Border(
              bottom: BorderSide(
                color: (isDarkMode
                    ? CupertinoColors.white
                    : CupertinoColors.black)
                    .withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center, // Centre verticalement
            children: [
              // Titre - Augmenté la taille du texte
              Text(
                title,
                style: TextStyle(
                  fontSize: 20, // Taille de texte augmentée
                  fontWeight: FontWeight.bold,
                  color: CupertinoTheme.of(context).textTheme.textStyle.color,
                ),
              ),

              // Bouton trailing optionnel
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurredTabBar(BuildContext context, bool isDarkMode) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 83, // Hauteur incluant le home indicator
          padding: const EdgeInsets.only(bottom: 30), // Espace pour le home indicator
          decoration: BoxDecoration(
            color: (isDarkMode
                ? CupertinoColors.black
                : CupertinoColors.white)
                .withOpacity(0.85),
            border: Border(
              top: BorderSide(
                color: (isDarkMode
                    ? CupertinoColors.white
                    : CupertinoColors.black)
                    .withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(context, 0, CupertinoIcons.home, 'Accueil'),
              _buildTabItem(context, 1, CupertinoIcons.news, 'Newsroom'),
              _buildTabItem(context, 2, CupertinoIcons.settings, 'Paramètres'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? CupertinoTheme.of(context).primaryColor
        : CupertinoColors.systemGrey;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}