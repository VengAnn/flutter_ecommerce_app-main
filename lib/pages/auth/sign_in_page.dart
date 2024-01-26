import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/custom_loader.dart';
import 'package:flutter_e_commerce_app_with_backend/base/show_custom_snack_bar.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/auth/sign_up_page.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/text_field_reusable_widget.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  bool checkHideOrShowPassword = true;

  void _login(AuthController authController) {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty) {
      showCustomSnackBar("Type the phone", title: "input phone");
    } else if (password.isEmpty) {
      showCustomSnackBar("Type the passowrd", title: "input password");
    } else if (password.length < 6) {
      showCustomSnackBar("Type password more then 6", title: "input password");
    } else {
      authController.login(phone, password).then(
        (status) {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
            //debugPrint(status.message);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(
      builder: (authController) {
        return authController.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height20 * 2.5),
                    Container(
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: Dimensions.radius20 * 4,
                          backgroundImage: const AssetImage(
                              "assets/images/virtual/vector3.png"),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width20,
                          ),
                          child: BigText(
                            text: "Hello",
                            fontWeight: FontWeight.bold,
                            size: Dimensions.fontSize20 * 3,
                          ),
                        ),
                      ],
                    ),
                    //
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width20,
                          ),
                          child: BigText(
                            text: "Sign into account",
                            fontWeight: FontWeight.bold,
                            size: Dimensions.fontSize20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(height: Dimensions.height10),
                    //phone
                    TextFieldReusableWidget(
                      textEditingController: phoneController,
                      hintText: "phone",
                      iconData: Icons.phone,
                      hideText: false,
                    ),
                    //
                    SizedBox(height: Dimensions.height10),
                    //Password
                    TextFieldReusableWidget(
                      textEditingController: passwordController,
                      hintText: "Password",
                      iconData: Icons.password,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            checkHideOrShowPassword = !checkHideOrShowPassword;
                          });
                        },
                        icon: checkHideOrShowPassword == true
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      hideText: checkHideOrShowPassword,
                    ),
                    //
                    SizedBox(height: Dimensions.height10),
                    //button sign Up
                    GestureDetector(
                      onTap: () {
                        _login(authController);
                      },
                      child: Container(
                        width: Dimensions.width20 * 8,
                        height: Dimensions.height20 * 3.5,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: Center(
                          child: BigText(
                            text: "Sign In",
                            size: Dimensions.fontSize20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    //
                    SizedBox(height: Dimensions.height10),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.fontSize20,
                        ),
                        children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(
                                      () => SignUpPage(),
                                      transition: Transition.fade,
                                    ),
                              text: " Create",
                              style: const TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
      },
    ));
  }
}
