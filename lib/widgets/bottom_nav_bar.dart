import 'package:flutter/material.dart';
import 'dart:ui';

class TranslucentBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final double blurStrength;

  const TranslucentBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.blurStrength = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final primaryColor = Theme.of(context).primaryColor;

    // Couleur de fond adaptée au thème
    final backgroundColor = isLightMode
        ? Colors.white.withOpacity(0.7)
        : const Color(0xFF1A1A1A).withOpacity(0.7);

    // Couleur de la bordure
    final borderColor = isLightMode
        ? Colors.grey.withOpacity(0.2)
        : Colors.white.withOpacity(0.1);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
        child: Container(
          height: 80, // Hauteur fixe pour la barre de navigation
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    icon: Icons.home_rounded,
                    label: 'Accueil',
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.newspaper_rounded,
                    label: 'Newsroom',
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.settings_rounded,
                    label: 'Paramètres',
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required int index,
        required bool isSelected,
      }) {
    final primaryColor = Theme.of(context).primaryColor;
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    // Couleurs adaptives pour les éléments sélectionnés/non-sélectionnés
    final selectedColor = primaryColor;
    final unselectedColor = isLightMode ? Colors.black54 : Colors.white54;

    // Couleur de l'élément actif
    final activeColor = isSelected ? selectedColor : unselectedColor;

    // Fond de l'élément actif
    final activeBackground = isSelected
        ? (isLightMode
        ? primaryColor.withOpacity(0.1)
        : primaryColor.withOpacity(0.15))
        : Colors.transparent;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 80,
        height: 52,
        decoration: BoxDecoration(
          color: activeBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: activeColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: activeColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}