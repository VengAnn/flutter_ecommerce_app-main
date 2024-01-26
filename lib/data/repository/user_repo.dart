import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({
    required this.apiClient,
  });

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
}
