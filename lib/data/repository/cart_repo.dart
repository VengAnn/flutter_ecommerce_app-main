import 'dart:convert';

import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/cart_model.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  //to save sharedPreference for local storage need type String
  List<String> cart = [];
  List<String> cartHistory = [];

  void addToCartList(List<CartModel> cartList) {
    // sharedPreferences.remove(AppConstants.CART_LIST);
    // sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    // return;
    var time = DateTime.now().toString();
    cart = [];
    /*
      convert object to string because sharePreference only accept String
    */
    //this loop one & one.. elemenet to list cart global
    cartList.forEach((element) {
      element.time = time;
      return cart.add(jsonEncode(element));
    });
    //save list to sharedpreference on local storage
    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    getCartList();
    // print(sharedPreferences.getStringList(AppConstants.CART_LIST));
  }

  List<CartModel> getCartList() {
    List<String> carts = []; //local list in this method
    //check if exist in sharedPreference that mean exist in local storage
    if (sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
      // print("inside getCartList ${carts.toString()}");
    }
    List<CartModel> cartList = [];
    //jsonDecode convert string to obj
    carts.forEach(
        (element) => cartList.add(CartModel.fromJson(jsonDecode(element))));
    return cartList;
  }

  void addToCartHistoryList() {
    //check sharedPreferences -> is local storage
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    //cart is global list type string
    for (int i = 0; i < cart.length; i++) {
      // print("History list ${cart[i]}");
      cartHistory.add(cart[i]); //pass cart to cart history
    }
    removeCart(); //when add to history already remove it on cartList
    //then save it to local storage with sharedPreference
    sharedPreferences.setStringList(
        AppConstants.CART_HISTORY_LIST, cartHistory);
    print("The of history List ${getCartHistoryList().length.toString()}");
    for (int j = 0; j < getCartHistoryList().length; j++) {
      print("Time order is: ${getCartHistoryList()[j].time}");
    }
  }

  void removeCart() {
    cart = [];
    sharedPreferences.remove(AppConstants.CART_LIST);
  }

  void clearCartHistory() {
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }

  List<CartModel> getCartHistoryList() {
    //check historylist exist or not
    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = [];
      cartHistory =
          sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    //we need list of obj to return for this method
    //because cartHistory is list of type string
    List<CartModel> cartHistoryList = [];
    //then we need to convert List type string to -> obj
    cartHistory.forEach((element) =>
        cartHistoryList.add(CartModel.fromJson(jsonDecode(element))));
    return cartHistoryList;
  }
}
