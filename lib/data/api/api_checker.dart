import 'package:flutter_e_commerce_app_with_backend/base/show_custom_snack_bar.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      // this mean user not login direct user to signIn page
      Get.offNamed(RouteHelper.getSignInPage());
    } else {
      showCustomSnackBar(response.statusText!);
    }
  }
}
