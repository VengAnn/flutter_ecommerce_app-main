import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../controller/popular_product_controller.dart';
import '../../controller/recommended_product_controller.dart';
import '../../utils/dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResouce() async {
    //load data from controller
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  void initState() {
    super.initState();
    _loadResouce();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(
      const Duration(seconds: 3),
      () => Get.offNamed(RouteHelper.getInitial()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
              scale: animation,
              child: Center(
                  child: Image.asset("assets/images/virtual/vector3.png"))),
          Center(
              child: BigText(
            text: "The best Food",
            size: Dimensions.fontSize20 * 2,
          )),
        ],
      ),
    );
  }
}
