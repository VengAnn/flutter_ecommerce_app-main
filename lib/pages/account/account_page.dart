import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/custom_loader.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/user_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/account_widget.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool _userLogged = Get.find<AuthController>().userLoggedIn();
    if (_userLogged) {
      Get.find<UserController>().getUserInfo();
      print("User has logged in");
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const BigText(text: "Profile", size: 24, color: Colors.white),
      ),
      body: GetBuilder<UserController>(
        builder: (usercontroller) {
          return _userLogged
              ? (usercontroller.isLoading
                  ? Column(
                      children: [
                        //Profile
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimensions.height20 * 8,
                              height: Dimensions.height20 * 8,
                              margin: EdgeInsets.only(top: Dimensions.height10),
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(Dimensions.radius10),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: Dimensions.height20 * 5,
                              ),
                            ),
                          ],
                        ),

                        //
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.height10),
                                AccountWidget(
                                  bigText: BigText(
                                      text: usercontroller.getUserModel!.phone),
                                  icon: Icons.call,
                                  color: Colors.amber,
                                ),
                                SizedBox(height: Dimensions.height10),
                                AccountWidget(
                                  bigText: BigText(
                                      text: usercontroller.getUserModel!.email),
                                  icon: Icons.mail_outline,
                                  color: Colors.amberAccent,
                                ),
                                SizedBox(height: Dimensions.height10),
                                GetBuilder<LocationController>(
                                  builder: (locationController) {
                                    // check if user already login and addressList is empty do ...
                                    if (_userLogged &&
                                        locationController
                                            .addressList.isEmpty) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              RouteHelper.getAddAddressPage());
                                        },
                                        child: AccountWidget(
                                            bigText: const BigText(
                                                text: "Fill in your Address"),
                                            icon: Icons.location_on),
                                      );
                                    } else {
                                      // and if check user already login and addressList is Not empty do..
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              RouteHelper.getAddAddressPage());
                                        },
                                        child: AccountWidget(
                                            bigText: const BigText(
                                                text: "Your Address"),
                                            icon: Icons.location_on),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: Dimensions.height10),
                                AccountWidget(
                                  bigText: const BigText(text: "Message"),
                                  icon: Icons.message_sharp,
                                  color: Colors.red,
                                ),
                                //Logout
                                GestureDetector(
                                  onTap: () {
                                    // when click logout clear anything
                                    if (Get.find<AuthController>()
                                        .userLoggedIn()) {
                                      Get.find<AuthController>()
                                          .clearSharePreferenceData();
                                      Get.find<CartController>().clear();
                                      Get.find<CartController>()
                                          .clearCartHistory();
                                      Get.find<LocationController>()
                                          .clearAddressList();
                                      Get.offNamed(RouteHelper.getSignInPage());
                                    }
                                  },
                                  child: AccountWidget(
                                      bigText: const BigText(text: "Logout"),
                                      icon: Icons.person),
                                ),
                                SizedBox(height: Dimensions.height10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : CustomLoader())
              : Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                        child: Text("You must Login"),
                      ),
                      //container for button login
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(RouteHelper.getSignInPage());
                        },
                        child: Container(
                          width: Dimensions.width20 * 10,
                          height: Dimensions.height20 * 5 / 2,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.width10),
                            color: Colors.green,
                          ),
                          child: const Center(child: BigText(text: "Sign In")),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
