import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/app_icon.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';
import '../../utils/app_constant.dart';
import '../../utils/dimensions.dart';
import '../../widgets/app_column.dart';

// ignore: must_be_immutable
class PopularFoodDetail extends StatelessWidget {
  int pageId;
  String page;
  PopularFoodDetail({super.key, required this.pageId, required this.page});

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<PopularProductController>().popularProductList[pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());
    return Scaffold(
      body: Stack(
        children: [
          //background Image
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "${AppConstants.BASE_URL}/uploads/${product.img}"), //
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          //icon widgets
          Positioned(
            top: Dimensions.height20 * 2,
            left: Dimensions.width10,
            right: Dimensions.width10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (page == "cartpage") {
                      Get.toNamed(RouteHelper.getCartPage());
                    } else {
                      Get.toNamed(RouteHelper.getInitial());
                    }
                  },
                  child: const AppIcon(icon: Icons.arrow_back_ios),
                ),
                GetBuilder<PopularProductController>(
                  builder: (controller) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getCartPage());
                      },
                      child: Stack(
                        children: [
                          const AppIcon(
                            icon: Icons.shopping_cart_outlined,
                            backgroundColor: AppColor.mainColor,
                            //  iconColor: AppColor.mainColor,
                          ),
                          controller.totalItems >= 1
                              ? const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: AppIcon(
                                    icon: Icons.circle,
                                    size: 20,
                                    iconColor: Colors.transparent,
                                  ),
                                )
                              : Container(),
                          //text number cart
                          controller.totalItems >= 1
                              ? Positioned(
                                  right: 5,
                                  top: 0,
                                  child: BigText(
                                    text: controller.totalItems.toString(),
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          //Introduction of Food
          Positioned(
            left: 0,
            right: 0,
            top: Dimensions.popularFoodImgSize - 20,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10,
                vertical: Dimensions.height10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius15),
                  topRight: Radius.circular(Dimensions.radius15),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(text: "${product.name}"),
                  SizedBox(
                    height: Dimensions.height10,
                  ),
                  BigText(
                    text: "Introduce",
                    size: Dimensions.height20,
                  ),
                  //
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          ExpandableTextWidget(text: "${product.description}"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //bottomNavigationBar
      bottomNavigationBar: GetBuilder<PopularProductController>(
        builder: (popularProduct) {
          return Container(
            height: Dimensions.bottomHieghtBar,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius15),
                topRight: Radius.circular(Dimensions.radius15),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height10,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            popularProduct.setQuantity(false);
                          },
                          child: const Icon(Icons.remove),
                        ),
                        SizedBox(
                          width: Dimensions.width5,
                        ),
                        BigText(
                          text: "${popularProduct.incrementItemCarts}",
                          size: Dimensions.fontSize21,
                        ),
                        SizedBox(
                          width: Dimensions.width5,
                        ),
                        GestureDetector(
                          onTap: () {
                            popularProduct.setQuantity(true);
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  //add to Cart
                  GestureDetector(
                    onTap: () {
                      popularProduct.addItem(product);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: Dimensions.height10,
                        bottom: Dimensions.height10,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[500],
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                      ),
                      child: Row(
                        children: [
                          BigText(
                            text: "\$ ${product.price} | Add to Cart",
                            color: Colors.white,
                            size: Dimensions.fontSize21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
