import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/auth_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/response_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/sign_up_body_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({
    required this.authRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //for toggle hide or show password icon in textfield
  bool checkHideOrShowPassword = true;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    //debugPrint("response controller: ${signUpBody.toJson()}");
    late ResponseModel
        responseModel; //create an obj and late need initialize later
    if (response.statusCode == 200) {
      //went we register success we'll has token sever given
      //we need save it to local storage sharePreferences
      authRepo.saveToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update(); //call method update tell UI what update to changed it realtime
    return responseModel;
  }

  void toggleIconHideShow() {
    checkHideOrShowPassword = !checkHideOrShowPassword;
    update();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone, password);
    late ResponseModel
        responseModel; //create an obj and late need initialize later
    if (response.statusCode == 200) {
      authRepo.saveToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  bool clearSharePreferenceData() {
    return authRepo.clearSharePreference();
  }
}
