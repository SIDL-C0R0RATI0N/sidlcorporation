import 'package:flutter/material.dart';
import 'dart:ui';

class TranslucentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final double height;

  const TranslucentAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.height = 56.0,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: preferredSize.height,
          decoration: BoxDecoration(
            color: isLightMode
                ? Colors.white.withOpacity(0.8)
                : Colors.black.withOpacity(0.8),
            border: Border(
              bottom: BorderSide(
                color: isLightMode
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: showBackButton && Navigator.canPop(context)
                ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            )
                : null,
            title: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isLightMode ? Colors.black : Colors.white,
                letterSpacing: 0.2,
              ),
            ),
            centerTitle: true,
            actions: actions,
          ),
        ),
      ),
    );
  }
}