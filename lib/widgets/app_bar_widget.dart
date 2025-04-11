import 'package:flutter/material.dart';
import 'dart:ui';

class TranslucentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final double height;
  final Color? backgroundColor;
  final double blurStrength;

  const TranslucentAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.height = 56.0,
    this.backgroundColor,
    this.blurStrength = 15.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;
    final primaryColor = Theme.of(context).primaryColor;

    // Définir les couleurs en fonction du mode
    final bgColor = backgroundColor ??
        (isLightMode
            ? Colors.white.withOpacity(0.7)
            : const Color(0xFF1A1A1A).withOpacity(0.7));

    final borderColor = isLightMode
        ? Colors.grey.withOpacity(0.2)
        : Colors.white.withOpacity(0.1);

    return Container(
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurStrength, sigmaY: blurStrength),
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                bottom: BorderSide(
                  color: borderColor,
                  width: 0.5,
                ),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: showBackButton && Navigator.canPop(context)
                  ? Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: isLightMode
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: isLightMode ? Colors.black : Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Retour',
                ),
              )
                  : null,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isLightMode ? Colors.black : Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              actions: actions != null
                  ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(children: actions!),
                ),
              ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}