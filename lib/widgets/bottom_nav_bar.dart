import 'package:flutter/material.dart';
import 'dart:ui';

class TranslucentBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TranslucentBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final primaryColor = Theme.of(context).primaryColor;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isLightMode
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.8),
            border: Border(
              top: BorderSide(
                color: isLightMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: currentIndex,
            onDestinationSelected: onTap,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Accueil',
              ),
              NavigationDestination(
                icon: Icon(Icons.newspaper_outlined),
                selectedIcon: Icon(Icons.newspaper),
                label: 'Newsroom',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Paramètres',
              ),
            ],
          ),
        ),
      ),
    );
  }
}