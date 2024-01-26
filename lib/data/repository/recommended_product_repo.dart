import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';

class RecommendedProductRepo extends GetxService {
  final ApiClient apiClient;
  RecommendedProductRepo({required this.apiClient});

  Future<Response> getRecommendedProductList() async {
    return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI);
  }
}
