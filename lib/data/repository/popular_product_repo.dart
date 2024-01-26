import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';

class PopularProductRepo extends GetxService {
  final ApiClient apiClient;
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async {
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }
}
