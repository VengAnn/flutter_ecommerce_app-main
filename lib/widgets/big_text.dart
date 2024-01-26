import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  const BigText({
    super.key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    this.fontWeight,
    this.textOverflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: textOverflow,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
