import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';

class TextFieldReusableWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData iconData;
  // ignore: non_constant_identifier_names
  final IconButton? suffixIcon;
  final bool hideText;

  const TextFieldReusableWidget({
    required this.textEditingController,
    required this.hintText,
    required this.iconData,
    // ignore: non_constant_identifier_names
    this.suffixIcon,
    required this.hideText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return //Texfield email
        Container(
      margin: EdgeInsets.only(
        left: Dimensions.width10 * 2,
        right: Dimensions.width10 * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 7,
            offset: const Offset(1, 10),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
      padding:
          EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            iconData,
            color: Colors.amber,
          ),
          suffixIcon: suffixIcon,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        obscureText: hideText,
      ),
    );
  }
}
