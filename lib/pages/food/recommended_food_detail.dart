import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/cart_page/cart_page.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/app_icon.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;
  const RecommendedFoodDetail(
      {required this.pageId, required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    var product =
        Get.find<RecommendedProductController>().recommendedPRoductList[pageId];
    Get.find<PopularProductController>()
        .initProduct(product, Get.find<CartController>());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: Dimensions.height20 * 4,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (page == "cartpage") {
                      Get.toNamed(RouteHelper.getCartPage());
                    } else {
                      Get.toNamed(
                          RouteHelper.getInitial()); //go to main Page Food
                    }
                  },
                  child: const AppIcon(icon: Icons.clear),
                ),
                //const AppIcon(icon: Icons.shopping_cart_outlined),
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
                          Get.find<PopularProductController>().totalItems >= 1
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
                          Get.find<PopularProductController>().totalItems >= 1
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
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height20 * 2),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: Dimensions.height5,
                  bottom: Dimensions.height10,
                ),
                child: Center(
                  child: BigText(
                    size: Dimensions.fontSize21,
                    text: "${product.name}",
                  ),
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Colors.yellow,
            expandedHeight: Dimensions.popularFoodImgSize,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "${AppConstants.BASE_URL}/uploads/${product.img}",
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                  child: ExpandableTextWidget(text: "${product.description}"),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          GetBuilder<PopularProductController>(builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(false);
                    },
                    child: AppIcon(
                      icon: Icons.remove,
                      size: Dimensions.iconSize17 * 2,
                    ),
                  ),
                  SizedBox(width: Dimensions.width20 * 2),
                  BigText(
                    text:
                        "\$ ${product.price} X ${controller.incrementItemCarts}",
                    size: Dimensions.fontSize20 * 1.5,
                  ),
                  SizedBox(width: Dimensions.width20 * 2),
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(true);
                    },
                    child: AppIcon(
                      icon: Icons.add,
                      size: Dimensions.iconSize17 * 2,
                    ),
                  ),
                ],
              ),
            ),
            //one more Container
            Container(
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
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.width5),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.addItem(product);
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
            ),
          ],
        );
      }),
    );
  }
}
