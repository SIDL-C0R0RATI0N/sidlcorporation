import 'dart:ui';
import 'package:flutter/cupertino.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurAmount;

  const BlurCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.blurAmount = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = CupertinoTheme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0x40000000)
                : const Color(0x40FFFFFF),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDarkMode
                  ? const Color(0x20FFFFFF)
                  : const Color(0x20000000),
              width: 0.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}