import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/no_data_page.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/models/cart_model.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/app_icon.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/small_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    //.reversed mean for show index by index (Mean when checkout items show in CartHistory it'll show on top above becasue it new added);
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();
    Map<String, int> cartItemsPerOrder = Map();

    for (int i = 0; i < getCartHistoryList.length; i++) {
      //check time by cartItemsPerOrder is exist or not for count number of time
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        //is already exist or the same time give value increment when check found it;
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        //not found the same value give it 1 mean the count is 1
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> cartItemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<String> cartOrderTimeToList() {
      //we get the key because key is save time
      //return it for this list cartOrderTimeToList of string
      return cartItemsPerOrder.entries.map((e) => e.key).toList();
    }

    //we read them one by one when the time 02/03/2022 3:30 have 2 and other time 3
    //each time have different items
    List<int> itemsPreOrder = cartItemsPerOrderToList();
    var listCounter = 0;
    Widget timeWidget(int index) {
      var outPutDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        //get list of time obj parse to string
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        //a =>mean am or pm
        var outPutFormat = DateFormat("MM/dd/yyyy HH:mm a");
        outPutDate = outPutFormat.format(inputDate);
      }
      return BigText(text: outPutDate);
    }

    return Scaffold(
      body: Column(
        children: [
          //header or appBar
          Container(
            color: Colors.green[300],
            padding: const EdgeInsets.only(
              top: 45,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const BigText(text: "Cart History"),
                AppIcon(
                  icon: Icons.shopping_cart,
                  size: Dimensions.iconSize17 * 1.7,
                  backgroundColor: Colors.amber,
                ),
              ],
            ),
          ),
          //body
          GetBuilder<CartController>(builder: (_cartController) {
            return _cartController.getCartHistoryList().length > 0
                ? Expanded(
                    child: Container(
                      //height: Dimensions.height20 * 6, //hieght = 120
                      margin: EdgeInsets.only(
                        top: Dimensions.height10,
                        left: Dimensions.height10,
                        right: Dimensions.height10,
                      ),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: [
                            for (int i = 0; i < itemsPreOrder.length; i++)
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.height10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /////
                                    timeWidget(listCounter),
                                    SizedBox(height: Dimensions.width10 / 7),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Wrap(
                                          direction: Axis.horizontal,
                                          children: List.generate(
                                            itemsPreOrder[i],
                                            (index) {
                                              //listCounter =0 that mean can check listCounter < alway smaller than getCartHistoryList.length
                                              //if ListCount !< getCartHistoryList.length => mean that (Error)
                                              if (listCounter <
                                                  getCartHistoryList.length) {
                                                listCounter++;
                                              }
                                              //check index to show only 3 index = 3 images Big than 3 not show
                                              return index <= 2
                                                  ? Container(
                                                      //hiegth=80=width
                                                      height:
                                                          Dimensions.height20 *
                                                              4,
                                                      width:
                                                          Dimensions.width20 *
                                                              4,
                                                      margin: EdgeInsets.only(
                                                        right:
                                                            Dimensions.width5,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                Dimensions
                                                                    .radius10)),
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "${AppConstants.BASE_URL}/uploads/${getCartHistoryList[listCounter - 1].img}"),
                                                        ),
                                                      ),
                                                    )
                                                  : Container();
                                            },
                                          ),
                                        ),
                                        //
                                        Container(
                                          // color: Colors.red,
                                          height: Dimensions.height20 * 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              SmallText(
                                                text: "Total",
                                                size: Dimensions.fontSize15,
                                              ),
                                              BigText(
                                                text:
                                                    "${itemsPreOrder[i].toString()} items",
                                                // color: Colors,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  //cartOrderTimeToList is function return the list
                                                  var orderTime =
                                                      cartOrderTimeToList();
                                                  Map<int, CartModel>
                                                      moreOrder = {};
                                                  for (int j = 0;
                                                      j <
                                                          getCartHistoryList
                                                              .length;
                                                      j++) {
                                                    //check time form cartContoller equal time ordertime by index
                                                    // ignore: unrelated_type_equality_checks
                                                    if (getCartHistoryList[j]
                                                            .time ==
                                                        orderTime[i]) {
                                                      moreOrder.putIfAbsent(
                                                        getCartHistoryList[j]
                                                            .id!,
                                                        () =>
                                                            //jsonEncode convert obj to sting json
                                                            //jsonDecode convert string  to Obj
                                                            CartModel.fromJson(
                                                          jsonDecode(
                                                            jsonEncode(
                                                              getCartHistoryList[
                                                                  j],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      Get.find<CartController>()
                                                          .setitems = moreOrder;
                                                      Get.find<CartController>()
                                                          .addToCartList();
                                                      Get.toNamed(RouteHelper
                                                          .getCartPage());
                                                    }
                                                  }
                                                  //print("Doing tesing ${orderTime[i]}");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions.width10,
                                                      vertical:
                                                          Dimensions.height10 /
                                                              4),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radius10),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                  ),
                                                  child: SmallText(
                                                    text: "one more",
                                                    size: Dimensions.fontSize15,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const NoDataPage(
                      text: "You didn't buy anything so far!🤔",
                      imagePath: "assets/images/real/empty_box.jpg",
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
