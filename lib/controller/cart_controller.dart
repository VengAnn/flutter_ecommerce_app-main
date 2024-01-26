import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/models/cart_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/product_model.dart';
import 'package:get/get.dart';

import '../data/repository/cart_repo.dart';
import '../utils/app_colors.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({required this.cartRepo}); //constructor
  Map<int, CartModel> _items = {}; //Map<key, value>
  Map<int, CartModel> get items => _items;

  //only for storage and sharedPreference
  List<CartModel> storageItems = [];
  void addItem(ProductModel product, int quantity) {
    var totalQuantity = 0;
    if (_items.containsKey(product.id)) {
      //update item in the map
      _items.update(product.id!, (value) {
        totalQuantity = value.quantity! + quantity;
        return CartModel(
          id: value.id,
          name: value.name,
          price: value.price,
          img: value.img,
          quantity: value.quantity! + quantity,
          isExist: true,
          time: DateTime.now().toString(),
          product: product,
        );
      });
      //check if totalQuantity <=0 remove it from map || or storage
      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }
    } else {
      if (quantity > 0) {
        //add new item to the map
        _items.putIfAbsent(product.id!, () {
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            isExist: true,
            //isExist that mean add or not in map
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        //alert snackbar when quantity < 0
        Get.snackbar(
          "Item Count",
          "You Should at least add an item in the Cart !",
          colorText: Colors.white,
          backgroundColor: AppColor.primaryColor,
        );
      }
    }
    //when addItem save it to cartRepo for save local storage
    cartRepo.addToCartList(getItems);
    update();
  }

  //check exist in cart
  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      return true;
    } else {
      return false;
    }
  }

  int getQuantity(ProductModel product) {
    var quantity = 0;
    if (_items.containsKey(product.id)) {
      _items.forEach((key, value) {
        if (key == product.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  //get totalItems for use in UI screen
  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getItems {
    //entries map like foreach
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  int get totalAmout {
    var total = 0;
    _items.forEach((key, value) {
      total += value.quantity! * value.price!;
    });
    return total;
  }

  //
  List<CartModel> getCartData() {
    setCart = cartRepo.getCartList();
    return storageItems;
  }

  set setCart(List<CartModel> items) {
    storageItems = items;
    // print("Length of CartItem ${storageItems.length.toString()}");
    for (int i = 0; i < storageItems.length; i++) {
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  //addToHistory instance with cartRepo
  void addToHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }

  void clear() {
    _items = {}; //Map
    update();
  }

  //getCartHistoryList for History
  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  //
  set setitems(Map<int, CartModel> setItems) {
    _items = {}; //make sure it empty and then pass Map throught argument
    _items = setItems;
  }

  void addToCartList() {
    cartRepo.addToCartList(getItems);
  }

  void clearCartHistory() {
    cartRepo.clearCartHistory();
    update();
  }
}
