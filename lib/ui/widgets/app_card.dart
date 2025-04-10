import 'dart:ui';
import 'package:flutter/cupertino.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool useBlur;

  const AppCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.useBlur = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;

    final cardWidget = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1E1E1E)
            : const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? const Color(0xFF000000).withOpacity(0.2)
                : const Color(0xFF000000).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (useBlur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1E1E1E).withOpacity(0.7)
                  : const Color(0xFFF5F5F7).withOpacity(0.7),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDarkMode
                    ? const Color(0xFFFFFFFF).withOpacity(0.1)
                    : const Color(0xFF000000).withOpacity(0.05),
                width: 0.5,
              ),
            ),
            child: child,
          ),
        ),
      );
    }

    return cardWidget;
  }
}