import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  const AppIcon({
    super.key,
    required this.icon,
    this.size = 40,
    this.iconColor = Colors.black,
    this.backgroundColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor,
          size: Dimensions.iconsize16,
        ),
      ),
    );
  }
}
