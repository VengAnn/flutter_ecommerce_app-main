import 'package:flutter_e_commerce_app_with_backend/data/repository/recommended_product_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/product_model.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController {
  final RecommendedProductRepo
      recommendedProductRepo; //create obj from RecommendedProductRepo
  RecommendedProductController({required this.recommendedProductRepo});

  List<ProductModel> _recommendedProductList = [];
  List<ProductModel> get recommendedPRoductList => _recommendedProductList;

  bool _isloading = false;
  bool get isLoading => _isloading;

  Future<void> getRecommendedProductList() async {
    _isloading = false;
    //with getx statemanagement have Response
    Response response =
        await recommendedProductRepo.getRecommendedProductList();

    if (response.statusCode == 200) {
      // print("got products");
      _recommendedProductList = [];
      _recommendedProductList.addAll(Product.fromJson(response.body).products);
      //print(response.body);
      _isloading = true;
      update();
    } else {}
  }
}
