import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';

class AccountWidget extends StatelessWidget {
  BigText bigText;
  IconData icon;
  double size;
  Color color;
  AccountWidget(
      {super.key,
      required this.bigText,
      required this.icon,
      this.size = 24,
      this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Dimensions.width20,
        top: Dimensions.height10,
        bottom: Dimensions.height10,
      ),
      // ignore: sort_child_properties_last
      child: Row(
        children: [
          //app icon
          Container(
            width: Dimensions.height20 * 2.2,
            height: Dimensions.height20 * 2.2,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(Dimensions.radius10),
            ),
            child: Icon(
              icon,
              size: size,
              color: Colors.white,
            ),
          ),
          SizedBox(width: Dimensions.width10),
          //text
          bigText,
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            offset: const Offset(0, 2),
            color: Colors.grey.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
