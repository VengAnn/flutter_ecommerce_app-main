import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/models/sign_up_body_model.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody) async {
    //this signUpBody is obj we need convert to json send to apiclient to server
    return await apiClient.postData(
        AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN) ?? "None";
  }

  Future<Response> login(String phone, String password) async {
    return await apiClient.postData(
      //the server need json we need convert email password to structure json
      AppConstants.LOGIN_URI,
      {"phone": phone, "password": password},
    );
  }

  Future<bool> saveToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    //we need to save token to local storage sharePreferences
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
      await sharedPreferences.setString(AppConstants.PHONE, number);
    } catch (e) {
      throw e;
    }
  }

  //clear everything if user logout
  bool clearSharePreference() {
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.PASSWORD);
    apiClient.token = "";
    apiClient.updateHeader("");
    return true;
  }
}
