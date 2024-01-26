import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  final String text;
  final String imagePath;
  const NoDataPage(
      {required this.text,
      this.imagePath = "assets/images/real/emptycart.png",
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          imagePath,
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width * 0.32,
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.001),
        Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.0175,
            color: Theme.of(context).disabledColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
