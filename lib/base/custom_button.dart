import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.transparent = false,
    this.margin,
    this.height = 60,
    this.width = 280,
    this.fontSize,
    this.radius = 5,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(
        width == null ? width! : Dimensions.screenWidth,
        height == null ? height! : 50,
      ),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
    );
    //
    return Center(
      child: SizedBox(
        width: width ?? Dimensions.screenWidth,
        child: TextButton(
          onPressed: onPressed,
          style: _flatButtonStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                      child: Icon(icon,
                          color: transparent
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor),
                    )
                  : const SizedBox(),
              //
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize ?? Dimensions.fontSize15,
                  color: transparent
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
