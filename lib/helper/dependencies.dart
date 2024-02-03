import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/user_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/auth_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/cart_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/location_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/popular_product_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/recommended_product_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/user_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//when app run on real time load all this mean(initialized)
Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  //api client
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthRepo(
      apiClient: Get.find(),
      sharedPreferences:
          Get.find())); //Get.find() it automatic find obj instance
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));

  //repositories
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  //controllers
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(
      () => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
}
