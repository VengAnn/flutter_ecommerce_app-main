import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/custom_loader.dart';
import 'package:flutter_e_commerce_app_with_backend/base/show_custom_snack_bar.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/models/response_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/sign_up_body_model.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/text_field_reusable_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  List listAssetImages = [
    'assets/images/virtual/fb.png',
    'assets/images/virtual/google.png',
    'assets/images/virtual/twitter.png',
  ];

  void _registration(AuthController authController) {
    String name = nameController.text.trim(); //trim mean get all like space
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty) {
      showCustomSnackBar("Type the name", title: "input name!");
    } else if (phone.isEmpty) {
      showCustomSnackBar("Type the phone", title: "input phone");
    } else if (email.isEmpty) {
      showCustomSnackBar("Type the email", title: "input email");
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar("Type the valid email", title: "input valid email");
    } else if (password.isEmpty) {
      showCustomSnackBar("Type the passowrd", title: "input password");
    } else if (password.length < 6) {
      showCustomSnackBar("Type password more then 6", title: "input password");
    } else {
      // showCustomSnackBar("All input corrected", title: "perfect");
      SignUpBody signUpBody = SignUpBody(
        name: name,
        password: password,
        phone: phone,
        email: email,
      );
      //call method registration in authController and pass the obj need
      authController.registration(signUpBody).then(
        (status) {
          if (status.isSuccess) {
            debugPrint("Success registration");
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCustomSnackBar(status.message);
            debugPrint(status.message);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(
        builder: (_authController) {
          return _authController.isLoading
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
                      //email
                      TextFieldReusableWidget(
                        textEditingController: emailController,
                        hintText: "Email",
                        iconData: Icons.email,
                        hideText: false,
                      ),
                      //
                      SizedBox(height: Dimensions.height10),
                      //
                      TextFieldReusableWidget(
                        textEditingController: passwordController,
                        hintText: "Password",
                        iconData: Icons.password,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _authController.toggleIconHideShow();
                          },
                          icon: _authController.checkHideOrShowPassword == true
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        hideText: _authController.checkHideOrShowPassword,
                      ),
                      //
                      SizedBox(height: Dimensions.height10),
                      //
                      TextFieldReusableWidget(
                        textEditingController: phoneController,
                        hintText: "Phone",
                        iconData: Icons.phone_android_outlined,
                        hideText: false,
                      ),
                      //
                      SizedBox(height: Dimensions.height10),
                      //
                      TextFieldReusableWidget(
                        textEditingController: nameController,
                        hintText: "Name",
                        iconData: Icons.person,
                        hideText: false,
                      ),
                      SizedBox(height: Dimensions.height10),
                      //button sign up
                      GestureDetector(
                        onTap: () {
                          _registration(_authController);
                        },
                        child: Container(
                          width: Dimensions.width20 * 8,
                          height: Dimensions.height20 * 3.5,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Center(
                            child: BigText(
                              text: "Sign Up",
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.back(),
                          text: "Have an account already?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimensions.fontSize20,
                          ),
                        ),
                      ),

                      SizedBox(height: Dimensions.height10 * 4),
                      const BigText(
                        text: "Sign up using one of the following method",
                        color: Colors.grey,
                      ),

                      Wrap(
                        children: List.generate(
                          listAssetImages.length,
                          (index) => Padding(
                            padding: EdgeInsets.all(Dimensions.width5),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image(
                                  // fit: BoxFit.cover,
                                  image: AssetImage(
                                    listAssetImages[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
