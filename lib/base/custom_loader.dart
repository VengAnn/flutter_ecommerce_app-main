import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    print("run customLoader");
    return Center(
      child: Container(
        width: Dimensions.height20 * 5,
        height: Dimensions.width20 * 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height20 * 5 / 2),
          color: Colors.amber,
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
