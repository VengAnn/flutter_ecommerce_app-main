import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/popular_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/recommended_product_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/models/product_model.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/food/popular_food_detail.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/app_column.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/icon_text_widget.dart';
import '../../widgets/small_text.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  //Propeties for pageview if you not use package name Carousel
  //   final PageController pageController = PageController(
  //   initialPage: 0,
  //   viewportFraction: 0.85,
  // );

  // var currentPageValue = 0.0;

  // @override
  // void initState() {
  //   pageController.addListener(() {
  //     currentPageValue = pageController.page!;
  //     setState(() {});
  //     //  print("currentPage: ${currentPageValue.toString()}");
  //   });
  //   super.initState();
  // }

  // //dispose
  // @override
  // void dispose() {
  //   pageController.dispose();
  //   super.dispose();
  // }
  // List<Widget> imageList = [
  //   ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: Image.asset(
  //         "assets/images/real/coffee.jpg",
  //         fit: BoxFit.cover,
  //       )),
  //   ClipRRect(
  //     borderRadius: BorderRadius.circular(20),
  //     child: Image.asset(
  //       "assets/images/real/apple_pie.jpg",
  //       fit: BoxFit.cover,
  //     ),
  //   ),
  //   ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: Image.asset(
  //         "assets/images/real/hamburger.jpg",
  //         fit: BoxFit.cover,
  //       )),
  // ];
  int currentPageValue = 0;

  @override
  Widget build(BuildContext context) {
    // print("currentHeight: ${MediaQuery.of(context).size.height}");
    //print("currentHeight: ${MediaQuery.of(context).size.width}");
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          // ignore: sized_box_for_whitespace
          GetBuilder<PopularProductController>(builder: (popularProducts) {
            return Container(
              height: Dimensions.parentCarouselContainer, // height: 350,
              // color: Colors.amber,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: Dimensions.carouselContainer,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  //reverse: false,
                  // autoPlay: true,
                  // autoPlayInterval: Duration(seconds: 3),
                  // autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.26,
                  onPageChanged: (index, reason) {
                    currentPageValue = index;
                    setState(() {});
                  },
                  scrollDirection: Axis.horizontal,
                ),
                items:
                    popularProducts.popularProductList.map((ProductModel obj) {
                  //ProductModel obj;
                  return Builder(
                    builder: (BuildContext context) {
                      return popularProducts.isloading
                          ? Stack(
                              clipBehavior:
                                  Clip.none, // Allow children to overflow
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      RouteHelper.getPopularFood(
                                          currentPageValue,
                                          "home"), //pass index for Route getPopularFood Go to popularDetail
                                    );
                                  },
                                  child: Container(
                                    width: Dimensions.screenWidth,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    // decoration: const BoxDecoration(color: Colors.amber),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${AppConstants.BASE_URL}/uploads/${obj.img}"),
                                      ),
                                    ), // Show imageList
                                  ),
                                ),
                                Positioned.fill(
                                  bottom: -Dimensions.height20,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: Dimensions.carouselTextContainer,
                                      // maybe height equal: 110,
                                      margin: EdgeInsets.only(
                                        left: Dimensions.paddingLeft20,
                                        right: Dimensions.paddingLeft20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 2,
                                            color: Colors.grey,
                                            offset: Offset(0, 5),
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 2.0,
                                            offset: Offset(-5, 0),
                                          ),
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 2.0,
                                            offset: Offset(5, 0),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(Dimensions.padding7),
                                        // ignore: avoid_unnecessary_containers
                                        child: Container(
                                          child: AppColumn(
                                            text: "${obj.description}",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                    },
                  );
                }).toList(),
              ),
            );
          }),
          //dot below slide food
          GetBuilder<PopularProductController>(
            builder: (popularProduts) {
              return Wrap(
                children: List.generate(
                  popularProduts.popularProductList.isEmpty
                      ? 1
                      : popularProduts.popularProductList.length,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: index == currentPageValue ? 20 : 10,
                      height: 5,
                      color: index == currentPageValue
                          ? Colors.yellow
                          : Colors.green,
                    ),
                  ),
                ),
              );
            },
          ),
          //Recomended Food
          Container(
            margin: EdgeInsets.only(left: Dimensions.padding7),
            child: Row(
              children: [
                BigText(
                  text: "Recommended",
                  size: Dimensions.fontSize21,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(
                  width: Dimensions.width5,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10),
                  child: SmallText(
                    text: '.',
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: Dimensions.width5,
                ),
                SmallText(
                  text: 'Food',
                  size: Dimensions.fontSize15,
                ),
              ],
            ),
          ),
          //
          Flexible(
            flex: 0, //when use Flex = 0 need to use shrinkWrap = true
            child: GetBuilder<RecommendedProductController>(
              builder: (recommendedProduct) {
                return recommendedProduct.isLoading
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap:
                            true, //to Confirm that ListView have an items
                        physics:
                            const NeverScrollableScrollPhysics(), //close scroll listview use parent with singlechildScrollview
                        itemCount:
                            recommendedProduct.recommendedPRoductList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: Dimensions.width10,
                              right: Dimensions.width10,
                              bottom: Dimensions.height10,
                            ),
                            child: Row(
                              children: [
                                //image Section
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getRecommendedFood(
                                        index, "home"));
                                  },
                                  child: Container(
                                    height: Dimensions.listviewContainer,
                                    width: Dimensions.listviewContainer,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${AppConstants.BASE_URL}/uploads/${recommendedProduct.recommendedPRoductList[index].img}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                //Text Section
                                Expanded(
                                  child: Container(
                                    height: Dimensions.listviewTextContainer,
                                    decoration: BoxDecoration(
                                      // color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                            Dimensions.radius20),
                                        bottomRight: Radius.circular(
                                            Dimensions.radius20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: Dimensions.width10,
                                        right: Dimensions.width10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          BigText(
                                            size: Dimensions.fontSize21,
                                            text:
                                                "${recommendedProduct.recommendedPRoductList[index].name}",
                                          ),
                                          // SizedBox(height: Dimensions.height5),
                                          SmallText(
                                            text:
                                                "With  Chinese characteristics",
                                            size: Dimensions.fontSize15,
                                            color: AppColor.mainColor,
                                          ),
                                          SizedBox(height: Dimensions.height5),
                                          //
                                          Container(
                                            width: Dimensions.screenWidth * 0.7,
                                            // height: 18,
                                            // color: Colors.amber,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconAndTextReusableWidget(
                                                  icondata: Icons.circle_sharp,
                                                  text: "Normal",
                                                  iconSize:
                                                      Dimensions.iconSize17,
                                                  sizeText:
                                                      Dimensions.fontSize15,
                                                  colorIcons: Colors.orange,
                                                ),
                                                IconAndTextReusableWidget(
                                                  icondata: Icons.location_on,
                                                  iconSize:
                                                      Dimensions.iconSize17,
                                                  colorIcons: Colors.green,
                                                  text: "1.7km",
                                                  sizeText:
                                                      Dimensions.fontSize15,
                                                ),
                                                IconAndTextReusableWidget(
                                                  icondata:
                                                      Icons.access_time_rounded,
                                                  iconSize:
                                                      Dimensions.iconSize17,
                                                  colorIcons:
                                                      AppColor.mainColor,
                                                  text: "33min",
                                                  sizeText:
                                                      Dimensions.fontSize15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const CircularProgressIndicator(color: Colors.blue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
