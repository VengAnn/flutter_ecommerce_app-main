import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/home/food_page_body.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/small_text.dart';
import 'package:get/get.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  Future<void> _loadResouce() async {
    //load data from controller
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        // ignore: sort_child_properties_last
        child: Column(
          children: [
            //Show Header
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      BigText(
                        text: "Country",
                        color: AppColor.mainColor,
                        fontWeight: FontWeight.bold,
                        size: Dimensions.fontSize15,
                      ),
                      Row(
                        children: [
                          SmallText(
                            text: "City",
                            size: Dimensions.fontSize15,
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: Dimensions.iconSizeHeight45,
                    height: Dimensions.iconSizeHeight45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: Dimensions.iconSize17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Show screen on body
            const Expanded(child: FoodPageBody()),
          ],
        ),
        onRefresh: _loadResouce);
  }
}
