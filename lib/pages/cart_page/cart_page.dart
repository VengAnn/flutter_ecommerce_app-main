import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/no_data_page.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/app_icon.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/small_text.dart';
import 'package:get/get.dart';

import '../../utils/app_constant.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Hearder
          Positioned(
            top: Dimensions.height20 * 3,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // Get.toNamed(RouteHelper.getPopularFood(pageId, page));
                    // Get.toNamed(RouteHelper.getRecommendedFood(pageId, page));
                    //Get.find<PopularProductController>().incrementItemCarts;
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back_ios,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.grey[200]!,
                    size: (Dimensions.iconsize16 * 2),
                  ),
                ),
                SizedBox(width: Dimensions.width20 * 5),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.initial);
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    iconColor: Colors.blue,
                    backgroundColor: Colors.grey[200]!,
                    size: (Dimensions.iconsize16 * 2),
                  ),
                ),
                AppIcon(
                  icon: Icons.shopping_cart,
                  iconColor: Colors.blue,
                  backgroundColor: Colors.grey[200]!,
                  size: (Dimensions.iconsize16 * 2),
                ),
              ],
            ),
          ),
          //body
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getItems.length > 0
                ? Positioned(
                    top: Dimensions.height20 * 5,
                    right: Dimensions.width10,
                    left: Dimensions.width10,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: Dimensions.height5),
                      width: double.maxFinite,
                      height: MediaQuery.sizeOf(context).height,
                      // color: Colors.blue,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: GetBuilder<CartController>(
                          builder: (cartController) {
                            var _cartList = cartController.getItems;
                            return ListView.builder(
                              itemCount: _cartList.length,
                              itemBuilder: (_, index) {
                                return Container(
                                  width: double.maxFinite,
                                  height: Dimensions.height20 * 5,
                                  child: Row(
                                    children: [
                                      //on container image
                                      GestureDetector(
                                        onTap: () {
                                          //when taped on image cartpage
                                          var popularIndex = Get.find<
                                                  PopularProductController>()
                                              .popularProductList
                                              .indexOf(
                                                  _cartList[index].product!);
                                          if (popularIndex >= 0) {
                                            Get.toNamed(
                                                RouteHelper.getPopularFood(
                                                    popularIndex, "cartpage"));
                                          } else {
                                            var recommendedIndex = Get.find<
                                                    RecommendedProductController>()
                                                .recommendedPRoductList
                                                .indexOf(
                                                    _cartList[index].product!);
                                            //check if recommendedIndex  <0 it mean is not available in cartpage history
                                            if (recommendedIndex < 0) {
                                              Get.snackbar(
                                                "History product",
                                                "Product preview not available for history product!",
                                                colorText: Colors.white,
                                                backgroundColor: Colors.amber,
                                              );
                                            } else {
                                              Get.toNamed(RouteHelper
                                                  .getRecommendedFood(
                                                      recommendedIndex,
                                                      "cartpage"));
                                            }
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: Dimensions.height5),
                                          width: Dimensions.width20 * 5,
                                          height: Dimensions.height20 * 5,
                                          decoration: BoxDecoration(
                                            //color: Colors.amber,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                "${AppConstants.BASE_URL}/uploads/${_cartList[index].img}",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.height20),
                                          ),
                                        ),
                                      ),
                                      //
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            bottom: Dimensions.height5,
                                            left: Dimensions.width5,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BigText(
                                                text:
                                                    "${_cartList[index].name}",
                                                size:
                                                    Dimensions.fontSize20 * 1.5,
                                                color: Colors.black54,
                                              ),
                                              SmallText(
                                                text: "spicy",
                                                size:
                                                    Dimensions.fontSize15 / 1.2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  BigText(
                                                    text:
                                                        "\$ ${cartController.getItems[index].price}",
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: Dimensions.height5 /
                                                          2.0,
                                                      bottom:
                                                          Dimensions.height5 /
                                                              2.0,
                                                      left: Dimensions.width20,
                                                      right: Dimensions.width20,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimensions
                                                                  .radius15),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartController.addItem(
                                                                _cartList[index]
                                                                    .product!,
                                                                -1);
                                                          },
                                                          child: const Icon(
                                                              Icons.remove),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Dimensions.width5,
                                                        ),
                                                        BigText(
                                                          text:
                                                              "${_cartList[index].quantity}",
                                                          size: Dimensions
                                                              .fontSize20,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Dimensions.width5,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            cartController.addItem(
                                                                _cartList[index]
                                                                    .product!,
                                                                1);
                                                          },
                                                          child: const Icon(
                                                              Icons.add),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : const NoDataPage(text: "Your cart is empty!!");
          }),
        ],
      ),
      //bottomNavigationBar
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (cartController) {
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
              //we check if getItems.length >0 show it but
              //when getItems.length=<0 show empty Container
              child: cartController.getItems.length > 0
                  ? Row(
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
                          child: Row(
                            children: [
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                              BigText(
                                text: "\$ ${cartController.totalAmout}",
                                size: Dimensions.fontSize21,
                              ),
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                            ],
                          ),
                        ),
                        //add to Cart
                        GestureDetector(
                          onTap: () {
                            //check user has loggedIn or not
                            if (Get.find<AuthController>().userLoggedIn()) {
                              //print("taped on checkout");
                              //cartController.addToHistory();

                              print("taped cart checkout");
                              // check if addressList is Empty or null we go to screen set address
                              if (Get.find<LocationController>()
                                  .addressList
                                  .isEmpty) {
                                Get.toNamed(RouteHelper.getAddAddressPage());
                              } else {
                                // but when addressList already has when click checkOut we go to homePage
                                Get.offNamed(RouteHelper.getInitial());
                              }
                            } else {
                              Get.toNamed(RouteHelper.getSignInPage());
                            }
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
                                  text: "Check Out",
                                  color: Colors.white,
                                  size: Dimensions.fontSize21,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          );
        },
      ),
    );
  }
}
