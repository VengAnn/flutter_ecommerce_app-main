import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  double? height = 1.1;
  //final TextOverflow? textOverflow;
  SmallText({
    super.key,
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 20,
    this.fontWeight,
    this.height,
    // this.textOverflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      // overflow: textOverflow,
      style: TextStyle(
        fontFamily: 'Roboto',
        height: height,
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
