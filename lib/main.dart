import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:get/get.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  //widgetsFlutterBinding make sure dependency is loaded correctly and wait process
  WidgetsFlutterBinding.ensureInitialized();
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //get for storage data or sharedPreference
    Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(builder: (_) {
      return GetBuilder<RecommendedProductController>(builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: RouteHelper.getSplashPage(),
          getPages: RouteHelper.routes,
        );
      });
    });
  }
}
