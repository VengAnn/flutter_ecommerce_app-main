import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/cart_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/popular_product_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/product_model.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:get/get.dart';

import '../models/cart_model.dart';

class PopularProductController extends GetxController {
  final PopularProductRepo popularProductRepo; //create obj from ProductRepo
  PopularProductController({required this.popularProductRepo});

  List<ProductModel> _popularProductList = [];

  List<ProductModel> get popularProductList => _popularProductList;

  // ignore: prefer_final_fields
  bool _isloading = false;

  bool get isloading => _isloading;

  int _quantity = 0;

  int get quantity => _quantity;
  int _incrementItemCarts = 0;

  int get incrementItemCarts => _incrementItemCarts + _quantity;

  late CartController _card; //initial later

  Future<void> getPopularProductList() async {
    _isloading = false;
    Response response = await popularProductRepo.getPopularProductList();
    // print("Response: ${response.body}");

    if (response.statusCode == 200) {
      _popularProductList = [];
      _popularProductList.addAll(Product.fromJson(response.body).products);
      _isloading = true;
      update();
    } else {
      _isloading = false;
    }
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    print(_quantity);
    update();
  }

  int checkQuantity(int quantity) {
    if ((_incrementItemCarts + quantity) < 0) {
      Get.snackbar(
        "Item Count",
        "You can't reduce more!",
        colorText: Colors.white,
        backgroundColor: AppColor.primaryColor,
      );

      if (_incrementItemCarts > 0) {
        _quantity = -_incrementItemCarts;
        return _quantity;
      }
      return 0;
    } else if ((_incrementItemCarts + quantity) > 20) {
      Get.snackbar(
        "Item Count",
        "You can't add more!",
        colorText: Colors.white,
        backgroundColor: AppColor.primaryColor,
      );
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController card) {
    _quantity = 0;
    _incrementItemCarts = 0;
    _card = card;
    var exist = false;
    exist = _card.existInCart(product);
    //if exists
    //get from storage _incrementItemsCarts
    // print("exist : ${exist.toString()}");
    if (exist) {
      _incrementItemCarts = _card.getQuantity(product);
    }
    // print("the quantity in the cart is ${_incrementItemCarts.toString()}");
  }

  //method addItems to cart
  void addItem(ProductModel product) {
    _card.addItem(product, _quantity);
    _quantity = 0;
    _incrementItemCarts = _card.getQuantity(product);
    _card.items.forEach((key, value) {
      // print(
      //   "The id is" +
      //       value.id.toString() +
      //       "The quantity is" +
      //       value.quantity.toString(),
      // );
    });
    update();
  }

  //get totalItems from CartController
  int get totalItems {
    return _card.totalItems;
  }

  //get list for cart screen
  List<CartModel> get getItems {
    return _card.getItems;
  }
}
